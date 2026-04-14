package com.chewy.admin.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chewy.admin.entity.Order;
import com.chewy.admin.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminOrderService {

    private final OrderMapper orderMapper;

    private static final List<String> VALID_STATUSES = List.of(
        "pending", "paid", "processing", "shipped", "delivered", "cancelled", "refunded"
    );

    /** 管理后台订单列表（支持状态/用户过滤） */
    public IPage<Order> listOrders(int page, int size, String status, Long userId) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
            .eq(StringUtils.hasText(status), Order::getStatus, status)
            .eq(userId != null, Order::getUserId, userId)
            .orderByDesc(Order::getCreatedAt);
        return orderMapper.selectPage(new Page<>(page, size), wrapper);
    }

    /** 更新订单状态 */
    @Transactional
    public Order updateOrderStatus(Long orderId, String newStatus) {
        if (!VALID_STATUSES.contains(newStatus)) {
            throw new RuntimeException("Invalid status: " + newStatus + ". Valid: " + VALID_STATUSES);
        }
        Order order = orderMapper.selectById(orderId);
        if (order == null) throw new RuntimeException("Order not found");
        order.setStatus(newStatus);
        orderMapper.updateById(order);
        return order;
    }
}
