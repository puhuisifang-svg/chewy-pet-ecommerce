package com.chewy.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.chewy.dto.auth.AuthResponse;
import com.chewy.dto.auth.LoginRequest;
import com.chewy.dto.auth.RegisterRequest;
import com.chewy.entity.User;
import com.chewy.mapper.UserMapper;
import com.chewy.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthResponse register(RegisterRequest req) {
        Long count = userMapper.selectCount(
            new LambdaQueryWrapper<User>().eq(User::getEmail, req.getEmail())
        );
        if (count > 0) {
            throw new RuntimeException("Email already registered");
        }
        User user = new User();
        user.setEmail(req.getEmail());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setUsername(req.getUsername());
        user.setFirstName(req.getFirstName());
        user.setLastName(req.getLastName());
        user.setStatus(1);
        userMapper.insert(user);
        String token = jwtUtil.generateToken(user.getId(), user.getEmail());
        return new AuthResponse(token, user.getId(), user.getUsername(), user.getEmail());
    }

    public AuthResponse login(LoginRequest req) {
        User user = userMapper.selectOne(
            new LambdaQueryWrapper<User>().eq(User::getEmail, req.getEmail())
        );
        if (user == null || !passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid email or password");
        }
        if (user.getStatus() != 1) {
            throw new RuntimeException("Account is disabled");
        }
        String token = jwtUtil.generateToken(user.getId(), user.getEmail());
        return new AuthResponse(token, user.getId(), user.getUsername(), user.getEmail());
    }
}
