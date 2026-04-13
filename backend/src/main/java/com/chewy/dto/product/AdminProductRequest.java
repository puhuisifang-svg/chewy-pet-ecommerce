package com.chewy.dto.product;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class AdminProductRequest {
    @NotNull
    private Long categoryId;
    @NotBlank
    private String spuCode;
    @NotBlank
    private String name;
    private String brand;
    private String description;
    @NotNull
    @DecimalMin("0.01")
    private BigDecimal price;
    private BigDecimal salePrice;
    private List<String> images;
    private List<String> tags;
    private Integer autoshipEligible = 1;
    private Integer status = 1;
    private List<SkuRequest> skus;

    @Data
    public static class SkuRequest {
        @NotBlank
        private String skuCode;
        private String specName;
        @NotNull
        private BigDecimal price;
        private BigDecimal salePrice;
        private Integer stock = 0;
        private BigDecimal weightLbs;
        private String barcode;
        private String image;
    }
}
