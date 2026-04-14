package com.chewy.product.dto.product;

import lombok.Data;

@Data
public class ProductQueryRequest {
    private Integer page = 1;
    private Integer size = 20;
    private Long categoryId;
    private String keyword;
    private String brand;
    private String sortBy = "createdAt";   // createdAt / price / name
    private String sortDir = "desc";        // asc / desc
    private Integer autoshipOnly;           // 1=仅AutoShip商品
}
