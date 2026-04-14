package com.chewy.cart.dto.cart;

import lombok.Data;
import java.util.List;

@Data
public class CartMergeRequest {
    private List<CartItemRequest> items;
}
