package com.chewy.payment.controller;

import com.chewy.common.Result;
import com.chewy.exception.UnauthorizedException;
import com.chewy.payment.service.PaymentService;
import com.chewy.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.Map;

@RestController
@RequestMapping("/api/payment")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PaymentController {
    private final PaymentService paymentService;
    private final JwtUtil jwtUtil;

    @PostMapping("/stripe/create-intent")
    public Result<Map<String, Object>> createStripeIntent(HttpServletRequest request,
            @RequestParam Long orderId, @RequestParam BigDecimal amount) {
        extractUserId(request);
        return Result.success(paymentService.createStripePaymentIntent(orderId, amount));
    }

    @PostMapping("/stripe/webhook")
    public Result<Void> stripeWebhook(HttpServletRequest request, @RequestBody String payload) {
        paymentService.handleStripeWebhook(payload, request.getHeader("Stripe-Signature"));
        return Result.success();
    }

    @PostMapping("/paypal/create-order")
    public Result<Map<String, String>> createPayPalOrder(HttpServletRequest request, @RequestParam Long orderId) {
        extractUserId(request);
        return Result.success(paymentService.createPayPalOrder(orderId));
    }

    @PostMapping("/paypal/capture")
    public Result<Map<String, String>> capturePayPal(HttpServletRequest request,
            @RequestParam String paypalOrderId, @RequestParam Long orderId) {
        extractUserId(request);
        return Result.success(paymentService.capturePayPalPayment(paypalOrderId, orderId));
    }

    private Long extractUserId(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer "))
            throw new UnauthorizedException("Login required");
        return jwtUtil.getUserId(header.substring(7));
    }
}
