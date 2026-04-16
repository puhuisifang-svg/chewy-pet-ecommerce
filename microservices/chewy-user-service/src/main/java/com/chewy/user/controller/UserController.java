package com.chewy.user.controller;

import com.chewy.common.Result;
import com.chewy.user.dto.user.AddressRequest;
import com.chewy.user.dto.user.UpdateProfileRequest;
import com.chewy.user.entity.User;
import com.chewy.user.entity.UserAddress;
import com.chewy.user.service.UserService;
import com.chewy.exception.UnauthorizedException;
import com.chewy.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {

    private final UserService userService;
    private final JwtUtil jwtUtil;

    /** GET /api/user/profile */
    @GetMapping("/profile")
    public Result<User> getProfile(HttpServletRequest request) {
        return Result.success(userService.getProfile(extractUserId(request)));
    }

    /** PUT /api/user/profile */
    @PutMapping("/profile")
    public Result<User> updateProfile(HttpServletRequest request,
                                       @Valid @RequestBody UpdateProfileRequest req) {
        return Result.success(userService.updateProfile(extractUserId(request), req));
    }

    /** GET /api/user/addresses */
    @GetMapping("/addresses")
    public Result<List<UserAddress>> listAddresses(HttpServletRequest request) {
        return Result.success(userService.listAddresses(extractUserId(request)));
    }

    /** POST /api/user/addresses */
    @PostMapping("/addresses")
    public Result<UserAddress> addAddress(HttpServletRequest request,
                                           @Valid @RequestBody AddressRequest req) {
        return Result.success(userService.addAddress(extractUserId(request), req));
    }

    /** PUT /api/user/addresses/{id} */
    @PutMapping("/addresses/{id}")
    public Result<UserAddress> updateAddress(HttpServletRequest request,
                                              @PathVariable("id") Long id,
                                              @Valid @RequestBody AddressRequest req) {
        return Result.success(userService.updateAddress(extractUserId(request), id, req));
    }

    /** DELETE /api/user/addresses/{id} */
    @DeleteMapping("/addresses/{id}")
    public Result<Void> deleteAddress(HttpServletRequest request,
                                       @PathVariable("id") Long id) {
        userService.deleteAddress(extractUserId(request), id);
        return Result.success();
    }

    /** PUT /api/user/addresses/{id}/default */
    @PutMapping("/addresses/{id}/default")
    public Result<UserAddress> setDefaultAddress(HttpServletRequest request,
                                                  @PathVariable("id") Long id) {
        return Result.success(userService.setDefaultAddress(extractUserId(request), id));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            throw new UnauthorizedException("Login required. Please provide a valid token.");
        }
        return jwtUtil.getUserId(header.substring(7));
    }
}
