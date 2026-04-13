package com.chewy.dto.product;

import com.chewy.entity.Product;
import com.chewy.entity.ProductSku;
import lombok.Data;
import java.util.List;

@Data
public class ProductDetailVO {
    private Product product;
    private List<ProductSku> skus;
}
