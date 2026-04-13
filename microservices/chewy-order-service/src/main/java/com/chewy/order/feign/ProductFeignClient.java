package com.chewy.order.feign;

import com.chewy.common.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * order-service → product-service (扣减/释放库存)
 */
@FeignClient(name = "chewy-product-service", path = "/internal")
public interface ProductFeignClient {
    @PutMapping("/skus/{skuId}/deduct-stock")
    Result<Void> deductStock(@PathVariable("skuId") Long skuId, @RequestParam("quantity") Integer quantity);

    @PutMapping("/skus/{skuId}/release-stock")
    Result<Void> releaseStock(@PathVariable("skuId") Long skuId, @RequestParam("quantity") Integer quantity);
}
