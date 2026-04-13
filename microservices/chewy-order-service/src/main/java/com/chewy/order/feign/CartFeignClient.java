package com.chewy.order.feign;

import com.chewy.common.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * order-service → cart-service (下单后清空购物车)
 */
@FeignClient(name = "chewy-cart-service", path = "/internal")
public interface CartFeignClient {
    @DeleteMapping("/cart/user/{userId}")
    Result<Void> clearCartByUser(@PathVariable("userId") Long userId);
}
