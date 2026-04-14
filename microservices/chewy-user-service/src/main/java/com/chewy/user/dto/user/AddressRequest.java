package com.chewy.user.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AddressRequest {
    @NotBlank(message = "Full name is required")
    private String fullName;
    private String phone;
    @NotBlank(message = "Address line 1 is required")
    private String addressLine1;
    private String addressLine2;
    @NotBlank(message = "City is required")
    private String city;
    @NotBlank(message = "State is required")
    private String state;
    @NotBlank(message = "Zip code is required")
    private String zipCode;
    private String country = "US";
    private Integer isDefault = 0;
}
