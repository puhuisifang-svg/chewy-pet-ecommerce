package com.chewy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chewy.common.Result;
import com.chewy.entity.Order;
import com.chewy.service.AdminOrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/orders")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminOrderController {

    private final AdminOrderService adminOrderService;

    /** GET /api/admin/orders */
    @GetMapping
    public Result<IPage<Order>> listOrders(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long userId) {
        return Result.success(adminOrderService.listOrders(page, size, status, userId));
    }

    /** PUT /api/admin/orders/{id}/status */
    @PutMapping("/{id}/status")
    public Result<Order> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String newStatus = body.get("status");
        if (newStatus == null || newStatus.isBlank()) {
            throw new RuntimeException("status field is required");
        }
        return Result.success(adminOrderService.updateOrderStatus(id, newStatus));
    }
}
