package com.chewy.product.controller;

import com.chewy.common.Result;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.chewy.product.entity.ProductSku;
import com.chewy.product.mapper.ProductSkuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 内部接口（仅供微服务间 Feign 调用，不对外暴露）
 * Gateway 路由中不包含 /internal 路径
 */
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
public class InternalProductController {

    private final ProductSkuMapper productSkuMapper;

    @PutMapping("/skus/{skuId}/deduct-stock")
    public Result<Void> deductStock(@PathVariable("skuId") Long skuId, @RequestParam Integer quantity) {
        ProductSku sku = productSkuMapper.selectById(skuId);
        if (sku == null) return Result.error(404, "SKU not found");
        int newStock = Math.max(0, sku.getStock() - quantity);
        sku.setStock(newStock);
        productSkuMapper.updateById(sku);
        return Result.success();
    }

    @PutMapping("/skus/{skuId}/release-stock")
    public Result<Void> releaseStock(@PathVariable("skuId") Long skuId, @RequestParam Integer quantity) {
        ProductSku sku = productSkuMapper.selectById(skuId);
        if (sku == null) return Result.error(404, "SKU not found");
        sku.setStock(sku.getStock() + quantity);
        productSkuMapper.updateById(sku);
        return Result.success();
    }
}
