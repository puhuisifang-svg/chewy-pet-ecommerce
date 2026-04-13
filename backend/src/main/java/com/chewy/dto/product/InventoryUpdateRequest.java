package com.chewy.dto.product;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class InventoryUpdateRequest {
    @NotNull
    private Long skuId;
    @NotNull
    @Min(0)
    private Integer stock;
}
