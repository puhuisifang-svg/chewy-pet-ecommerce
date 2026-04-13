package com.chewy.controller;

import com.chewy.common.Result;
import com.chewy.dto.cart.*;
import com.chewy.service.CartService;
import com.chewy.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CartController {

    private final CartService cartService;
    private final JwtUtil jwtUtil;

    /** POST /api/cart/items - 加入购物车 */
    @PostMapping("/items")
    public Result<CartVO> addItem(HttpServletRequest request,
                                   @Valid @RequestBody CartItemRequest req) {
        Long userId = extractUserId(request);
        return Result.success(cartService.addItem(userId, req));
    }

    /** GET /api/cart - 获取购物车 */
    @GetMapping
    public Result<CartVO> getCart(HttpServletRequest request) {
        Long userId = extractUserId(request);
        return Result.success(cartService.getCart(userId));
    }

    /** PUT /api/cart/items/{id} - 修改数量 */
    @PutMapping("/items/{id}")
    public Result<CartVO> updateItem(HttpServletRequest request,
                                      @PathVariable Long id,
                                      @Valid @RequestBody CartItemUpdateRequest req) {
        Long userId = extractUserId(request);
        return Result.success(cartService.updateItem(userId, id, req));
    }

    /** DELETE /api/cart/items/{id} - 删除单项 */
    @DeleteMapping("/items/{id}")
    public Result<CartVO> removeItem(HttpServletRequest request,
                                      @PathVariable Long id) {
        Long userId = extractUserId(request);
        return Result.success(cartService.removeItem(userId, id));
    }

    /** DELETE /api/cart - 清空购物车 */
    @DeleteMapping
    public Result<Void> clearCart(HttpServletRequest request) {
        Long userId = extractUserId(request);
        cartService.clearCart(userId);
        return Result.success();
    }

    /** POST /api/cart/merge - 游客购物车合并 */
    @PostMapping("/merge")
    public Result<CartVO> mergeCart(HttpServletRequest request,
                                     @RequestBody CartMergeRequest req) {
        Long userId = extractUserId(request);
        return Result.success(cartService.mergeCart(userId, req));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            throw new RuntimeException("Unauthorized");
        }
        return jwtUtil.getUserId(header.substring(7));
    }
}
