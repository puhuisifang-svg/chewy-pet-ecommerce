package com.chewy.order.dto.order;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class CreateOrderRequest {
    @NotNull(message = "Shipping address is required")
    private ShippingAddressDTO shippingAddress;
    private String note;
    private String paymentMethod;
    @NotEmpty(message = "Order items cannot be empty")
    private List<OrderItemDTO> items;

    @Data
    public static class ShippingAddressDTO {
        private String fullName;
        private String phone;
        private String addressLine1;
        private String addressLine2;
        private String city;
        private String state;
        private String zipCode;
        private String country = "US";
    }

    @Data
    public static class OrderItemDTO {
        @NotNull private Long skuId;
        @NotNull private Long productId;
        private String productName;
        private String skuCode;
        private String specName;
        @NotNull private BigDecimal price;
        @NotNull private Integer quantity;
    }
}
