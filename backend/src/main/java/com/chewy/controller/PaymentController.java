package com.chewy.controller;

import com.chewy.common.Result;
import com.chewy.service.PaymentService;
import com.chewy.exception.UnauthorizedException;
import com.chewy.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payment")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PaymentController {

    private final PaymentService paymentService;
    private final JwtUtil jwtUtil;

    /** POST /api/payment/stripe/create-intent - 创建 Stripe PaymentIntent */
    @PostMapping("/stripe/create-intent")
    public Result<Map<String, String>> createStripeIntent(
            HttpServletRequest request,
            @RequestParam Long orderId) {
        Long userId = extractUserId(request);
        return Result.success(paymentService.createStripePaymentIntent(orderId, userId));
    }

    /** POST /api/payment/stripe/webhook - Stripe Webhook 回调 */
    @PostMapping("/stripe/webhook")
    public Result<Void> stripeWebhook(
            HttpServletRequest request,
            @RequestBody String payload) {
        String sigHeader = request.getHeader("Stripe-Signature");
        paymentService.handleStripeWebhook(payload, sigHeader);
        return Result.success();
    }

    /** POST /api/payment/paypal/create-order - 创建 PayPal 订单 */
    @PostMapping("/paypal/create-order")
    public Result<Map<String, String>> createPayPalOrder(
            HttpServletRequest request,
            @RequestParam Long orderId) {
        Long userId = extractUserId(request);
        return Result.success(paymentService.createPayPalOrder(orderId, userId));
    }

    /** POST /api/payment/paypal/capture - 捕获 PayPal 支付 */
    @PostMapping("/paypal/capture")
    public Result<Map<String, String>> capturePayPal(
            HttpServletRequest request,
            @RequestParam String paypalOrderId,
            @RequestParam Long orderId) {
        Long userId = extractUserId(request);
        return Result.success(paymentService.capturePayPalPayment(paypalOrderId, orderId, userId));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            throw new UnauthorizedException("Login required. Please provide a valid token.");
        }
        return jwtUtil.getUserId(header.substring(7));
    }
}
