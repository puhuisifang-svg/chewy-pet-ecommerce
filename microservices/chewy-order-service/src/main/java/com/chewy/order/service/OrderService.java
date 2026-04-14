package com.chewy.order.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chewy.order.dto.order.CreateOrderRequest;
import com.chewy.order.dto.order.OrderDetailVO;
import com.chewy.order.entity.Order;
import com.chewy.order.entity.OrderItem;
import com.chewy.order.feign.ProductFeignClient;
import com.chewy.order.feign.CartFeignClient;
import com.chewy.order.mapper.OrderMapper;
import com.chewy.order.mapper.OrderItemMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderService {

    private static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("49.00");
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("4.95");
    private static final BigDecimal TAX_RATE = new BigDecimal("0.08");

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductFeignClient productFeignClient;
    private final CartFeignClient cartFeignClient;
    private final ObjectMapper objectMapper;

    /**
     * 创建订单（items 由前端传入，不再依赖 cart-service 读取）
     * 前端在下单时传 items 列表，order-service 通过 Feign 扣库存
     */
    @Transactional
    public OrderDetailVO createOrder(Long userId, CreateOrderRequest req) {
        if (req.getItems() == null || req.getItems().isEmpty()) {
            throw new RuntimeException("Order items cannot be empty");
        }

        // 计算金额
        BigDecimal subtotal = req.getItems().stream()
            .map(i -> i.getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal shippingFee = subtotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0 ? BigDecimal.ZERO : SHIPPING_FEE;
        BigDecimal taxAmount = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal totalAmount = subtotal.add(shippingFee).add(taxAmount);

        // 序列化收货地址
        String shippingAddressJson;
        try { shippingAddressJson = objectMapper.writeValueAsString(req.getShippingAddress()); }
        catch (Exception e) { throw new RuntimeException("Address serialization error"); }

        // 创建订单
        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setSubtotal(subtotal);
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setShippingFee(shippingFee);
        order.setTaxAmount(taxAmount);
        order.setTotalAmount(totalAmount);
        order.setStatus("pending");
        order.setFulfillmentType("overseas_warehouse");
        order.setPaymentMethod(req.getPaymentMethod());
        order.setShippingAddress(shippingAddressJson);
        order.setNote(req.getNote());
        orderMapper.insert(order);

        // 创建订单明细 + 通过 Feign 扣减库存
        List<OrderItem> orderItems = new ArrayList<>();
        for (CreateOrderRequest.OrderItemDTO item : req.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setOrderId(order.getId());
            oi.setProductId(item.getProductId());
            oi.setSkuId(item.getSkuId());
            oi.setProductName(item.getProductName());
            oi.setSkuCode(item.getSkuCode());
            oi.setSpecName(item.getSpecName());
            oi.setPrice(item.getPrice());
            oi.setQuantity(item.getQuantity());
            oi.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            orderItemMapper.insert(oi);
            orderItems.add(oi);
            // Feign 扣库存（失败时记录日志，不阻断下单）
            try {
                productFeignClient.deductStock(item.getSkuId(), item.getQuantity());
            } catch (Exception e) {
                log.warn("Feign deductStock failed for skuId={}: {}", item.getSkuId(), e.getMessage());
            }
        }

        // Feign 清空购物车
        try { cartFeignClient.clearCartByUser(userId); }
        catch (Exception e) { log.warn("Feign clearCart failed for userId={}: {}", userId, e.getMessage()); }

        OrderDetailVO vo = new OrderDetailVO();
        vo.setOrder(order);
        vo.setItems(orderItems);
        return vo;
    }

    public IPage<Order> listOrders(Long userId, int page, int size) {
        return orderMapper.selectPage(new Page<>(page, size),
            new LambdaQueryWrapper<Order>().eq(Order::getUserId, userId).orderByDesc(Order::getCreatedAt));
    }

    public OrderDetailVO getOrderDetail(Long userId, Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) throw new RuntimeException("Order not found");
        List<OrderItem> items = orderItemMapper.selectList(
            new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
        OrderDetailVO vo = new OrderDetailVO();
        vo.setOrder(order); vo.setItems(items);
        return vo;
    }

    @Transactional
    public Order cancelOrder(Long userId, Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) throw new RuntimeException("Order not found");
        if (!List.of("pending", "paid").contains(order.getStatus()))
            throw new RuntimeException("Cannot cancel order in status: " + order.getStatus());
        order.setStatus("cancelled");
        orderMapper.updateById(order);
        // Feign 释放库存
        List<OrderItem> items = orderItemMapper.selectList(
            new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
        items.forEach(item -> {
            try { productFeignClient.releaseStock(item.getSkuId(), item.getQuantity()); }
            catch (Exception e) { log.warn("Feign releaseStock failed: {}", e.getMessage()); }
        });
        return order;
    }

    private String generateOrderNo() {
        String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "CP" + ts + ThreadLocalRandom.current().nextInt(1000, 9999);
    }
}
