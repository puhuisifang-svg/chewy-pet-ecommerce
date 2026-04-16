package com.chewy.product.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chewy.common.Result;
import com.chewy.product.dto.product.*;
import com.chewy.product.entity.Category;
import com.chewy.product.entity.Product;
import com.chewy.product.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductService productService;

    /** GET /api/products - 商品列表 */
    @GetMapping("/api/products")
    public Result<IPage<Product>> listProducts(ProductQueryRequest req) {
        return Result.success(productService.listProducts(req));
    }

    /** GET /api/products/{id} - 商品详情（含SKU） */
    @GetMapping("/api/products/{id}")
    public Result<ProductDetailVO> getProduct(@PathVariable("id") Long id) {
        return Result.success(productService.getProductDetail(id));
    }

    /** GET /api/categories - 分类列表 */
    @GetMapping("/api/categories")
    public Result<List<Category>> listCategories() {
        return Result.success(productService.listCategories());
    }

    /** GET /api/admin/products - 管理后台商品列表（复用 listProducts） */
    @GetMapping("/api/admin/products")
    public Result<IPage<Product>> adminListProducts(ProductQueryRequest req) {
        return Result.success(productService.listProducts(req));
    }

    /** POST /api/admin/products - 新增商品 */
    @PostMapping("/api/admin/products")
    public Result<Product> createProduct(@Valid @RequestBody AdminProductRequest req) {
        return Result.success(productService.createProduct(req));
    }

    /** PUT /api/admin/products/{id} - 编辑商品 */
    @PutMapping("/api/admin/products/{id}")
    public Result<Product> updateProduct(@PathVariable("id") Long id,
                                          @Valid @RequestBody AdminProductRequest req) {
        return Result.success(productService.updateProduct(id, req));
    }

    /** DELETE /api/admin/products/{id} - 删除商品（软删除） */
    @DeleteMapping("/api/admin/products/{id}")
    public Result<Void> deleteProduct(@PathVariable("id") Long id) {
        productService.deleteProduct(id);
        return Result.success();
    }

    /** PUT /api/admin/products/{id}/inventory - 更新库存 */
    @PutMapping("/api/admin/products/{id}/inventory")
    public Result<Void> updateInventory(@PathVariable("id") Long id,
                                         @Valid @RequestBody InventoryUpdateRequest req) {
        productService.updateInventory(id, req);
        return Result.success();
    }
}
