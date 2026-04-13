package com.chewy.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chewy.dto.product.*;
import com.chewy.entity.Category;
import com.chewy.entity.Product;
import com.chewy.entity.ProductSku;
import com.chewy.mapper.CategoryMapper;
import com.chewy.mapper.ProductMapper;
import com.chewy.mapper.ProductSkuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductMapper productMapper;
    private final ProductSkuMapper productSkuMapper;
    private final CategoryMapper categoryMapper;
    private final ObjectMapper objectMapper;

    /** 商品列表（分页+筛选+排序） */
    public IPage<Product> listProducts(ProductQueryRequest req) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .eq(Product::getStatus, 1)
                .eq(req.getCategoryId() != null, Product::getCategoryId, req.getCategoryId())
                .eq(StringUtils.hasText(req.getBrand()), Product::getBrand, req.getBrand())
                .eq(req.getAutoshipOnly() != null && req.getAutoshipOnly() == 1, Product::getAutoshipEligible, 1)
                .and(StringUtils.hasText(req.getKeyword()), w -> w
                        .like(Product::getName, req.getKeyword())
                        .or().like(Product::getBrand, req.getKeyword())
                        .or().like(Product::getDescription, req.getKeyword())
                );

        // 排序
        boolean asc = "asc".equalsIgnoreCase(req.getSortDir());
        switch (req.getSortBy()) {
            case "price" -> wrapper.orderBy(true, asc, Product::getPrice);
            case "name"  -> wrapper.orderBy(true, asc, Product::getName);
            default      -> wrapper.orderBy(true, asc, Product::getCreatedAt);
        }

        Page<Product> page = new Page<>(req.getPage(), req.getSize());
        return productMapper.selectPage(page, wrapper);
    }

    /** 商品详情（含SKU列表） */
    public ProductDetailVO getProductDetail(Long id) {
        Product product = productMapper.selectById(id);
        if (product == null || product.getStatus() != 1) {
            throw new RuntimeException("Product not found");
        }
        List<ProductSku> skus = productSkuMapper.selectList(
                new LambdaQueryWrapper<ProductSku>()
                        .eq(ProductSku::getProductId, id)
                        .eq(ProductSku::getStatus, 1)
        );
        ProductDetailVO vo = new ProductDetailVO();
        vo.setProduct(product);
        vo.setSkus(skus);
        return vo;
    }

    /** 分类列表 */
    public List<Category> listCategories() {
        return categoryMapper.selectList(
                new LambdaQueryWrapper<Category>()
                        .eq(Category::getStatus, 1)
                        .orderByAsc(Category::getSortOrder)
        );
    }

    /** 管理：新增商品（含SKU） */
    @Transactional
    public Product createProduct(AdminProductRequest req) {
        Product product = new Product();
        fillProductFromRequest(product, req);
        productMapper.insert(product);
        saveSkus(product.getId(), req.getSkus());
        return product;
    }

    /** 管理：编辑商品 */
    @Transactional
    public Product updateProduct(Long id, AdminProductRequest req) {
        Product product = productMapper.selectById(id);
        if (product == null) throw new RuntimeException("Product not found");
        fillProductFromRequest(product, req);
        productMapper.updateById(product);
        // 删除旧SKU，重新插入
        productSkuMapper.delete(new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, id));
        saveSkus(id, req.getSkus());
        return product;
    }

    /** 管理：删除商品（软删除） */
    @Transactional
    public void deleteProduct(Long id) {
        Product product = productMapper.selectById(id);
        if (product == null) throw new RuntimeException("Product not found");
        product.setStatus(0);
        productMapper.updateById(product);
    }

    /** 管理：更新SKU库存 */
    @Transactional
    public void updateInventory(Long productId, InventoryUpdateRequest req) {
        ProductSku sku = productSkuMapper.selectById(req.getSkuId());
        if (sku == null || !sku.getProductId().equals(productId)) {
            throw new RuntimeException("SKU not found");
        }
        sku.setStock(req.getStock());
        productSkuMapper.updateById(sku);
    }

    // ---- private helpers ----

    private void fillProductFromRequest(Product product, AdminProductRequest req) {
        product.setCategoryId(req.getCategoryId());
        product.setSpuCode(req.getSpuCode());
        product.setName(req.getName());
        product.setBrand(req.getBrand());
        product.setDescription(req.getDescription());
        product.setPrice(req.getPrice());
        product.setSalePrice(req.getSalePrice());
        product.setAutoshipEligible(req.getAutoshipEligible());
        product.setStatus(req.getStatus());
        try {
            product.setImages(req.getImages() != null ? objectMapper.writeValueAsString(req.getImages()) : null);
            product.setTags(req.getTags() != null ? objectMapper.writeValueAsString(req.getTags()) : null);
        } catch (Exception e) {
            throw new RuntimeException("JSON serialization error");
        }
    }

    private void saveSkus(Long productId, List<AdminProductRequest.SkuRequest> skuRequests) {
        if (skuRequests == null || skuRequests.isEmpty()) return;
        for (AdminProductRequest.SkuRequest sr : skuRequests) {
            ProductSku sku = new ProductSku();
            sku.setProductId(productId);
            sku.setSkuCode(sr.getSkuCode());
            sku.setSpecName(sr.getSpecName());
            sku.setPrice(sr.getPrice());
            sku.setSalePrice(sr.getSalePrice());
            sku.setStock(sr.getStock() != null ? sr.getStock() : 0);
            sku.setWeightLbs(sr.getWeightLbs());
            sku.setBarcode(sr.getBarcode());
            sku.setImage(sr.getImage());
            sku.setStatus(1);
            productSkuMapper.insert(sku);
        }
    }
}
