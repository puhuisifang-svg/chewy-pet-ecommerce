package com.chewy.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.chewy.dto.cart.*;
import com.chewy.entity.CartItem;
import com.chewy.entity.Product;
import com.chewy.entity.ProductSku;
import com.chewy.mapper.CartItemMapper;
import com.chewy.mapper.ProductMapper;
import com.chewy.mapper.ProductSkuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartService {

    private static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("49.00");
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("4.95");
    private static final int MAX_QUANTITY = 99;

    private final CartItemMapper cartItemMapper;
    private final ProductSkuMapper productSkuMapper;
    private final ProductMapper productMapper;

    /** 加入购物车 */
    @Transactional
    public CartVO addItem(Long userId, CartItemRequest req) {
        ProductSku sku = getSkuOrThrow(req.getSkuId());
        // 库存检查
        if (sku.getStock() < req.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + sku.getStock());
        }
        // 是否已存在同 SKU
        CartItem existing = cartItemMapper.selectOne(
            new LambdaQueryWrapper<CartItem>()
                .eq(CartItem::getUserId, userId)
                .eq(CartItem::getSkuId, req.getSkuId())
        );
        if (existing != null) {
            int newQty = Math.min(existing.getQuantity() + req.getQuantity(), MAX_QUANTITY);
            if (sku.getStock() < newQty) {
                throw new RuntimeException("Insufficient stock. Available: " + sku.getStock());
            }
            existing.setQuantity(newQty);
            cartItemMapper.updateById(existing);
        } else {
            CartItem item = new CartItem();
            item.setUserId(userId);
            item.setSkuId(req.getSkuId());
            item.setProductId(sku.getProductId());
            item.setQuantity(req.getQuantity());
            item.setIsAutoship(req.getIsAutoship() != null ? req.getIsAutoship() : 0);
            cartItemMapper.insert(item);
        }
        return buildCartVO(userId);
    }

    /** 获取购物车 */
    public CartVO getCart(Long userId) {
        return buildCartVO(userId);
    }

    /** 修改商品数量 */
    @Transactional
    public CartVO updateItem(Long userId, Long itemId, CartItemUpdateRequest req) {
        CartItem item = getCartItemOrThrow(userId, itemId);
        ProductSku sku = getSkuOrThrow(item.getSkuId());
        if (sku.getStock() < req.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + sku.getStock());
        }
        item.setQuantity(req.getQuantity());
        cartItemMapper.updateById(item);
        return buildCartVO(userId);
    }

    /** 删除单项 */
    @Transactional
    public CartVO removeItem(Long userId, Long itemId) {
        CartItem item = getCartItemOrThrow(userId, itemId);
        cartItemMapper.deleteById(item.getId());
        return buildCartVO(userId);
    }

    /** 清空购物车 */
    @Transactional
    public void clearCart(Long userId) {
        cartItemMapper.delete(
            new LambdaQueryWrapper<CartItem>().eq(CartItem::getUserId, userId)
        );
    }

    /** 游客购物车合并（登录后调用） */
    @Transactional
    public CartVO mergeCart(Long userId, CartMergeRequest req) {
        if (req.getItems() == null || req.getItems().isEmpty()) {
            return buildCartVO(userId);
        }
        for (CartItemRequest guestItem : req.getItems()) {
            try {
                addItem(userId, guestItem);
            } catch (RuntimeException e) {
                // 库存不足时跳过，不中断整体合并
            }
        }
        return buildCartVO(userId);
    }

    // ---- private helpers ----

    private CartVO buildCartVO(Long userId) {
        List<CartItem> items = cartItemMapper.selectList(
            new LambdaQueryWrapper<CartItem>().eq(CartItem::getUserId, userId)
        );
        if (items.isEmpty()) {
            CartVO vo = new CartVO();
            vo.setItems(new ArrayList<>());
            vo.setTotalQty(0);
            vo.setSubtotal(BigDecimal.ZERO);
            vo.setFreeShipping(false);
            vo.setShippingFee(SHIPPING_FEE);
            vo.setTotal(SHIPPING_FEE);
            return vo;
        }

        // 批量查 SKU
        List<Long> skuIds = items.stream().map(CartItem::getSkuId).collect(Collectors.toList());
        List<ProductSku> skus = productSkuMapper.selectBatchIds(skuIds);
        Map<Long, ProductSku> skuMap = skus.stream().collect(Collectors.toMap(ProductSku::getId, s -> s));

        // 批量查 Product
        List<Long> productIds = items.stream().map(CartItem::getProductId).distinct().collect(Collectors.toList());
        List<Product> products = productMapper.selectBatchIds(productIds);
        Map<Long, Product> productMap = products.stream().collect(Collectors.toMap(Product::getId, p -> p));

        List<CartVO.CartItemVO> itemVOs = new ArrayList<>();
        BigDecimal subtotal = BigDecimal.ZERO;
        int totalQty = 0;

        for (CartItem cartItem : items) {
            ProductSku sku = skuMap.get(cartItem.getSkuId());
            Product product = productMap.get(cartItem.getProductId());
            if (sku == null || product == null) continue;

            CartVO.CartItemVO vo = new CartVO.CartItemVO();
            vo.setCartItemId(cartItem.getId());
            vo.setSkuId(sku.getId());
            vo.setProductId(product.getId());
            vo.setProductName(product.getName());
            vo.setSkuCode(sku.getSkuCode());
            vo.setSpecName(sku.getSpecName());
            vo.setImage(sku.getImage() != null ? sku.getImage() : (product.getImages() != null ? product.getImages() : ""));
            // 促销价优先
            BigDecimal price = sku.getSalePrice() != null ? sku.getSalePrice() : sku.getPrice();
            vo.setPrice(price);
            vo.setQuantity(cartItem.getQuantity());
            vo.setStock(sku.getStock());
            vo.setOutOfStock(sku.getStock() < cartItem.getQuantity());
            vo.setIsAutoship(cartItem.getIsAutoship());
            BigDecimal lineTotal = price.multiply(BigDecimal.valueOf(cartItem.getQuantity()));
            vo.setLineTotal(lineTotal);

            itemVOs.add(vo);
            subtotal = subtotal.add(lineTotal);
            totalQty += cartItem.getQuantity();
        }

        boolean freeShipping = subtotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0;
        BigDecimal shippingFee = freeShipping ? BigDecimal.ZERO : SHIPPING_FEE;

        CartVO cartVO = new CartVO();
        cartVO.setItems(itemVOs);
        cartVO.setTotalQty(totalQty);
        cartVO.setSubtotal(subtotal);
        cartVO.setFreeShipping(freeShipping);
        cartVO.setShippingFee(shippingFee);
        cartVO.setTotal(subtotal.add(shippingFee));
        return cartVO;
    }

    private ProductSku getSkuOrThrow(Long skuId) {
        ProductSku sku = productSkuMapper.selectById(skuId);
        if (sku == null || sku.getStatus() != 1) {
            throw new RuntimeException("SKU not found or unavailable");
        }
        return sku;
    }

    private CartItem getCartItemOrThrow(Long userId, Long itemId) {
        CartItem item = cartItemMapper.selectById(itemId);
        if (item == null || !item.getUserId().equals(userId)) {
            throw new RuntimeException("Cart item not found");
        }
        return item;
    }
}
