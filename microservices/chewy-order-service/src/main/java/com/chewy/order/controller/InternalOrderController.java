package com.chewy.order.controller;

import com.chewy.common.Result;
import com.chewy.order.entity.Order;
import com.chewy.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 内部接口（仅供 payment-service Feign 调用）
 */
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
public class InternalOrderController {

    private final OrderMapper orderMapper;

    @PutMapping("/orders/{orderId}/payment-status")
    public Result<Void> updatePaymentStatus(
            @PathVariable Long orderId,
            @RequestParam String status,
            @RequestParam String paymentIntentId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) return Result.error(404, "Order not found");
        order.setStatus(status);
        order.setPaymentIntentId(paymentIntentId);
        orderMapper.updateById(order);
        return Result.success();
    }
}
