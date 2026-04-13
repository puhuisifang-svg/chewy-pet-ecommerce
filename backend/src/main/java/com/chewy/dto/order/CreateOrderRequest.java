package com.chewy.dto.order;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateOrderRequest {
    @NotNull(message = "Shipping address is required")
    private ShippingAddressDTO shippingAddress;
    private String note;
    private String paymentMethod; // stripe / paypal

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
}
