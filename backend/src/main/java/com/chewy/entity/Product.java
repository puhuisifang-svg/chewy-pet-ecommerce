package com.chewy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("products")
public class Product {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long categoryId;
    private String spuCode;
    private String name;
    private String brand;
    private String description;
    private BigDecimal price;
    private BigDecimal salePrice;
    private String images;   // JSON string
    private String tags;     // JSON string
    private Integer autoshipEligible;
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
