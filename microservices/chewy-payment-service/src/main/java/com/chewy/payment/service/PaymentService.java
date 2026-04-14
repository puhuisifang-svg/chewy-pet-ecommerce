package com.chewy.payment.service;

import com.chewy.payment.feign.OrderFeignClient;
import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentService {

    @Value("${payment.stripe.secret-key}")
    private String stripeSecretKey;
    @Value("${payment.stripe.webhook-secret}")
    private String stripeWebhookSecret;
    @Value("${payment.paypal.enabled:false}")
    private boolean paypalEnabled;

    private final OrderFeignClient orderFeignClient;

    public Map<String, Object> createStripePaymentIntent(Long orderId, BigDecimal amount) {
        try {
            Stripe.apiKey = stripeSecretKey;
            long amountCents = amount.multiply(BigDecimal.valueOf(100)).longValue();
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                .setAmount(amountCents).setCurrency("usd")
                .putMetadata("orderId", String.valueOf(orderId))
                .setAutomaticPaymentMethods(
                    PaymentIntentCreateParams.AutomaticPaymentMethods.builder().setEnabled(true).build())
                .build();
            PaymentIntent intent = PaymentIntent.create(params);
            Map<String, Object> result = new HashMap<>();
            result.put("clientSecret", intent.getClientSecret());
            result.put("paymentIntentId", intent.getId());
            result.put("orderId", orderId);
            result.put("amount", amount);
            return result;
        } catch (Exception e) {
            log.error("Stripe createPaymentIntent error: {}", e.getMessage());
            throw new RuntimeException("Payment service error: " + e.getMessage());
        }
    }

    public void handleStripeWebhook(String payload, String sigHeader) {
        try {
            com.stripe.model.Event event = com.stripe.net.Webhook.constructEvent(payload, sigHeader, stripeWebhookSecret);
            log.info("Stripe webhook: {}", event.getType());
            if ("payment_intent.succeeded".equals(event.getType())) {
                event.getDataObjectDeserializer().getObject().ifPresent(obj -> {
                    if (obj instanceof PaymentIntent pi) {
                        String orderIdStr = pi.getMetadata().get("orderId");
                        if (orderIdStr != null) {
                            try {
                                orderFeignClient.updatePaymentStatus(Long.parseLong(orderIdStr), "paid", pi.getId());
                                log.info("Order {} marked as paid via Feign", orderIdStr);
                            } catch (Exception e) {
                                log.error("Feign updatePaymentStatus failed: {}", e.getMessage());
                            }
                        }
                    }
                });
            }
        } catch (Exception e) {
            log.error("Stripe webhook error: {}", e.getMessage());
            throw new RuntimeException("Webhook error: " + e.getMessage());
        }
    }

    public Map<String, String> createPayPalOrder(Long orderId) {
        if (!paypalEnabled) {
            return Map.of("status", "UNAVAILABLE", "message", "PayPal payment is not available yet. Please use Stripe.");
        }
        return Map.of("status", "PENDING_CONFIGURATION");
    }

    public Map<String, String> capturePayPalPayment(String paypalOrderId, Long orderId) {
        if (!paypalEnabled) {
            return Map.of("status", "UNAVAILABLE", "message", "PayPal payment is not available yet. Please use Stripe.");
        }
        try {
            orderFeignClient.updatePaymentStatus(orderId, "paid", paypalOrderId);
        } catch (Exception e) {
            log.error("Feign updatePaymentStatus (paypal) failed: {}", e.getMessage());
        }
        return Map.of("status", "COMPLETED", "paypalOrderId", paypalOrderId, "orderId", String.valueOf(orderId));
    }
}
