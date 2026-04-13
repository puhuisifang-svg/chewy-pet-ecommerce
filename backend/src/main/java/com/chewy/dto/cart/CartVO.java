package com.chewy.dto.cart;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class CartVO {
    private List<CartItemVO> items;
    private Integer totalQty;
    private BigDecimal subtotal;
    private BigDecimal shippingFee;
    private BigDecimal total;
    private Boolean freeShipping;

    @Data
    public static class CartItemVO {
        private Long cartItemId;
        private Long skuId;
        private Long productId;
        private String productName;
        private String skuCode;
        private String specName;
        private String image;
        private BigDecimal price;          // SKU 实际售价（含促销价逻辑）
        private Integer quantity;
        private Integer stock;
        private Boolean outOfStock;
        private Integer isAutoship;
        private BigDecimal lineTotal;
    }
}
