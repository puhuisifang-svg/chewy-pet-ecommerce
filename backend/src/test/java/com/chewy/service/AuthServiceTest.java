package com.chewy.service;

import com.chewy.dto.auth.LoginRequest;
import com.chewy.dto.auth.RegisterRequest;
import com.chewy.entity.User;
import com.chewy.mapper.UserMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * AuthService 单元测试
 * 框架：JUnit5 + Mockito
 * 覆盖：用户注册/登录正常流程 + 异常流程
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("AuthService 用户注册/登录测试")
class AuthServiceTest {

    @Mock
    private UserMapper userMapper;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private AuthService authService;

    private RegisterRequest validRegisterRequest;
    private LoginRequest validLoginRequest;

    @BeforeEach
    void setUp() {
        validRegisterRequest = new RegisterRequest();
        validRegisterRequest.setEmail("test@example.com");
        validRegisterRequest.setPassword("Test1234");

        validLoginRequest = new LoginRequest();
        validLoginRequest.setEmail("test@example.com");
        validLoginRequest.setPassword("Test1234");
    }

    // ==================== 注册测试 ====================

    @Test
    @DisplayName("TC-REG-001 【正常】新用户注册成功")
    void testRegister_Success() {
        // given
        when(userMapper.selectByEmail(anyString())).thenReturn(null);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(userMapper.insert(any(User.class))).thenReturn(1);

        // when & then
        assertDoesNotThrow(() -> authService.register(validRegisterRequest));
        verify(userMapper, times(1)).insert(any(User.class));
    }

    @Test
    @DisplayName("TC-REG-003 【异常】重复邮箱注册应抛出异常")
    void testRegister_DuplicateEmail_ThrowsException() {
        // given
        User existingUser = new User();
        existingUser.setEmail("test@example.com");
        when(userMapper.selectByEmail("test@example.com")).thenReturn(existingUser);

        // when & then
        RuntimeException ex = assertThrows(RuntimeException.class,
            () -> authService.register(validRegisterRequest));
        assertTrue(ex.getMessage().contains("已被注册") || ex.getMessage().contains("already exists"));
        verify(userMapper, never()).insert(any());
    }

    // ==================== 登录测试 ====================

    @Test
    @DisplayName("TC-LOGIN-001 【正常】正确账密登录返回token")
    void testLogin_Success() {
        // given
        User mockUser = new User();
        mockUser.setEmail("test@example.com");
        mockUser.setPassword("encodedPassword");
        when(userMapper.selectByEmail("test@example.com")).thenReturn(mockUser);
        when(passwordEncoder.matches("Test1234", "encodedPassword")).thenReturn(true);

        // when & then
        assertDoesNotThrow(() -> authService.login(validLoginRequest));
    }

    @Test
    @DisplayName("TC-LOGIN-003 【异常】密码错误应抛出认证异常")
    void testLogin_WrongPassword_ThrowsException() {
        // given
        User mockUser = new User();
        mockUser.setEmail("test@example.com");
        mockUser.setPassword("encodedPassword");
        when(userMapper.selectByEmail("test@example.com")).thenReturn(mockUser);
        when(passwordEncoder.matches("WrongPwd1", "encodedPassword")).thenReturn(false);

        LoginRequest wrongPwdRequest = new LoginRequest();
        wrongPwdRequest.setEmail("test@example.com");
        wrongPwdRequest.setPassword("WrongPwd1");

        // when & then
        RuntimeException ex = assertThrows(RuntimeException.class,
            () -> authService.login(wrongPwdRequest));
        assertNotNull(ex.getMessage());
    }

    @Test
    @DisplayName("TC-LOGIN-005 【异常】未注册邮箱登录应抛出异常")
    void testLogin_UnregisteredEmail_ThrowsException() {
        // given
        when(userMapper.selectByEmail("notexist@example.com")).thenReturn(null);

        LoginRequest unknownEmailRequest = new LoginRequest();
        unknownEmailRequest.setEmail("notexist@example.com");
        unknownEmailRequest.setPassword("Test1234");

        // when & then
        assertThrows(RuntimeException.class,
            () -> authService.login(unknownEmailRequest));
    }
}
