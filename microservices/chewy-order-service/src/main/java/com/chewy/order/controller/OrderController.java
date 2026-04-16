package com.chewy.order.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chewy.common.Result;
import com.chewy.exception.UnauthorizedException;
import com.chewy.order.dto.order.CreateOrderRequest;
import com.chewy.order.dto.order.OrderDetailVO;
import com.chewy.order.entity.Order;
import com.chewy.order.service.OrderService;
import com.chewy.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class OrderController {
    private final OrderService orderService;
    private final JwtUtil jwtUtil;

    @PostMapping
    public Result<OrderDetailVO> createOrder(HttpServletRequest req, @Valid @RequestBody CreateOrderRequest body) {
        return Result.success(orderService.createOrder(extractUserId(req), body));
    }
    @GetMapping
    public Result<IPage<Order>> listOrders(HttpServletRequest req,
            @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {
        return Result.success(orderService.listOrders(extractUserId(req), page, size));
    }
    @GetMapping("/{id}")
    public Result<OrderDetailVO> getOrder(HttpServletRequest req, @PathVariable("id") Long id) {
        return Result.success(orderService.getOrderDetail(extractUserId(req), id));
    }
    @PutMapping("/{id}/cancel")
    public Result<Order> cancelOrder(HttpServletRequest req, @PathVariable("id") Long id) {
        return Result.success(orderService.cancelOrder(extractUserId(req), id));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer "))
            throw new UnauthorizedException("Login required");
        return jwtUtil.getUserId(header.substring(7));
    }
}
