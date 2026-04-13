package com.chewy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chewy.common.Result;
import com.chewy.dto.order.CreateOrderRequest;
import com.chewy.dto.order.OrderDetailVO;
import com.chewy.entity.Order;
import com.chewy.service.OrderService;
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

    /** POST /api/orders - 创建订单 */
    @PostMapping
    public Result<OrderDetailVO> createOrder(HttpServletRequest request,
                                              @Valid @RequestBody CreateOrderRequest req) {
        return Result.success(orderService.createOrder(extractUserId(request), req));
    }

    /** GET /api/orders - 订单列表 */
    @GetMapping
    public Result<IPage<Order>> listOrders(HttpServletRequest request,
                                            @RequestParam(defaultValue = "1") int page,
                                            @RequestParam(defaultValue = "10") int size) {
        return Result.success(orderService.listOrders(extractUserId(request), page, size));
    }

    /** GET /api/orders/{id} - 订单详情 */
    @GetMapping("/{id}")
    public Result<OrderDetailVO> getOrder(HttpServletRequest request,
                                           @PathVariable Long id) {
        return Result.success(orderService.getOrderDetail(extractUserId(request), id));
    }

    /** PUT /api/orders/{id}/cancel - 取消订单 */
    @PutMapping("/{id}/cancel")
    public Result<Order> cancelOrder(HttpServletRequest request,
                                      @PathVariable Long id) {
        return Result.success(orderService.cancelOrder(extractUserId(request), id));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            throw new RuntimeException("Unauthorized");
        }
        return jwtUtil.getUserId(header.substring(7));
    }
}
