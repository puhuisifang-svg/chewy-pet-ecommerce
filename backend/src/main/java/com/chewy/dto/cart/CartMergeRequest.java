package com.chewy.dto.cart;

import lombok.Data;
import java.util.List;

@Data
public class CartMergeRequest {
    private List<CartItemRequest> items;
}
