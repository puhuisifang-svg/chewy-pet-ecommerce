package com.chewy.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chewy.dto.cart.CartVO;
import com.chewy.dto.order.CreateOrderRequest;
import com.chewy.dto.order.OrderDetailVO;
import com.chewy.entity.*;
import com.chewy.mapper.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
public class OrderService {

    private static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("49.00");
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("4.95");
    private static final BigDecimal TAX_RATE = new BigDecimal("0.08"); // 8% 销售税（简化）

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final CartItemMapper cartItemMapper;
    private final ProductSkuMapper productSkuMapper;
    private final ProductMapper productMapper;
    private final CartService cartService;
    private final ObjectMapper objectMapper;

    /** 创建订单（从购物车生成，锁定库存） */
    @Transactional
    public OrderDetailVO createOrder(Long userId, CreateOrderRequest req) {
        // 获取购物车
        CartVO cart = cartService.getCart(userId);
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }
        // 检查是否有缺货商品
        boolean hasOutOfStock = cart.getItems().stream().anyMatch(CartVO.CartItemVO::getOutOfStock);
        if (hasOutOfStock) {
            throw new RuntimeException("Some items are out of stock, please update your cart");
        }

        // 计算金额
        BigDecimal subtotal = cart.getSubtotal();
        BigDecimal shippingFee = subtotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0
                ? BigDecimal.ZERO : SHIPPING_FEE;
        BigDecimal taxAmount = subtotal.multiply(TAX_RATE).setScale(2, java.math.RoundingMode.HALF_UP);
        BigDecimal totalAmount = subtotal.add(shippingFee).add(taxAmount);

        // 生成订单号
        String orderNo = generateOrderNo();

        // 序列化收货地址
        String shippingAddressJson;
        try {
            shippingAddressJson = objectMapper.writeValueAsString(req.getShippingAddress());
        } catch (Exception e) {
            throw new RuntimeException("Address serialization error");
        }

        // 创建订单
        Order order = new Order();
        order.setOrderNo(orderNo);
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

        // 创建订单明细 + 扣减库存
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartVO.CartItemVO cartItem : cart.getItems()) {
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(cartItem.getProductId());
            item.setSkuId(cartItem.getSkuId());
            item.setProductName(cartItem.getProductName());
            item.setSkuCode(cartItem.getSkuCode());
            item.setSpecName(cartItem.getSpecName());
            item.setPrice(cartItem.getPrice());
            item.setQuantity(cartItem.getQuantity());
            item.setSubtotal(cartItem.getLineTotal());
            orderItemMapper.insert(item);
            orderItems.add(item);

            // 扣减库存
            ProductSku sku = productSkuMapper.selectById(cartItem.getSkuId());
            if (sku != null) {
                int newStock = Math.max(0, sku.getStock() - cartItem.getQuantity());
                sku.setStock(newStock);
                productSkuMapper.updateById(sku);
            }
        }

        // 清空购物车
        cartService.clearCart(userId);

        OrderDetailVO vo = new OrderDetailVO();
        vo.setOrder(order);
        vo.setItems(orderItems);
        return vo;
    }

    /** 用户订单列表（分页） */
    public IPage<Order> listOrders(Long userId, int page, int size) {
        return orderMapper.selectPage(
            new Page<>(page, size),
            new LambdaQueryWrapper<Order>()
                .eq(Order::getUserId, userId)
                .orderByDesc(Order::getCreatedAt)
        );
    }

    /** 订单详情 */
    public OrderDetailVO getOrderDetail(Long userId, Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new RuntimeException("Order not found");
        }
        List<OrderItem> items = orderItemMapper.selectList(
            new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId)
        );
        OrderDetailVO vo = new OrderDetailVO();
        vo.setOrder(order);
        vo.setItems(items);
        return vo;
    }

    /** 取消订单（释放库存） */
    @Transactional
    public Order cancelOrder(Long userId, Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new RuntimeException("Order not found");
        }
        if (!List.of("pending", "paid").contains(order.getStatus())) {
            throw new RuntimeException("Cannot cancel order in status: " + order.getStatus());
        }
        order.setStatus("cancelled");
        orderMapper.updateById(order);

        // 释放库存
        List<OrderItem> items = orderItemMapper.selectList(
            new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId)
        );
        for (OrderItem item : items) {
            ProductSku sku = productSkuMapper.selectById(item.getSkuId());
            if (sku != null) {
                sku.setStock(sku.getStock() + item.getQuantity());
                productSkuMapper.updateById(sku);
            }
        }
        return order;
    }

    private String generateOrderNo() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int random = ThreadLocalRandom.current().nextInt(1000, 9999);
        return "CP" + timestamp + random;
    }
}
