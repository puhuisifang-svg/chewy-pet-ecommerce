package com.chewy.cart.controller;

import com.chewy.common.Result;
import com.chewy.cart.entity.CartItem;
import com.chewy.cart.mapper.CartItemMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 内部接口（仅供 order-service Feign 调用）
 */
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
public class InternalCartController {

    private final CartItemMapper cartItemMapper;

    @DeleteMapping("/cart/user/{userId}")
    public Result<Void> clearCartByUser(@PathVariable("userId") Long userId) {
        cartItemMapper.delete(
            new LambdaQueryWrapper<CartItem>().eq(CartItem::getUserId, userId)
        );
        return Result.success();
    }
}
