package com.chewy.user.dto.user;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UpdateProfileRequest {
    @Size(min = 2, max = 50)
    private String username;
    private String firstName;
    private String lastName;
    private String phone;
    private String avatar;
}
