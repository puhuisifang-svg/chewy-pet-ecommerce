package com.chewy.service;

import com.chewy.entity.Order;
import com.chewy.mapper.OrderMapper;
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

    @Value("${payment.paypal.client-id}")
    private String paypalClientId;

    @Value("${payment.paypal.client-secret}")
    private String paypalClientSecret;

    @Value("${payment.paypal.mode}")
    private String paypalMode;

    private final OrderMapper orderMapper;

    /**
     * 创建 Stripe PaymentIntent
     * @param orderId 订单ID
     * @return clientSecret（前端用于确认支付）
     */
    public Map<String, String> createStripePaymentIntent(Long orderId, Long userId) {
        Order order = getOrderOrThrow(orderId, userId);
        try {
            Stripe.apiKey = stripeSecretKey;
            // 金额转为分（cents）
            long amountCents = order.getTotalAmount()
                    .multiply(BigDecimal.valueOf(100))
                    .longValue();
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                    .setAmount(amountCents)
                    .setCurrency("usd")
                    .putMetadata("orderId", String.valueOf(orderId))
                    .putMetadata("orderNo", order.getOrderNo())
                    .setAutomaticPaymentMethods(
                        PaymentIntentCreateParams.AutomaticPaymentMethods.builder()
                            .setEnabled(true)
                            .build()
                    )
                    .build();
            PaymentIntent intent = PaymentIntent.create(params);
            // 保存 paymentIntentId 到订单
            order.setPaymentIntentId(intent.getId());
            orderMapper.updateById(order);

            Map<String, String> result = new HashMap<>();
            result.put("clientSecret", intent.getClientSecret());
            result.put("paymentIntentId", intent.getId());
            result.put("orderId", String.valueOf(orderId));
            result.put("amount", String.valueOf(order.getTotalAmount()));
            return result;
        } catch (Exception e) {
            log.error("Stripe createPaymentIntent error: {}", e.getMessage());
            throw new RuntimeException("Payment service error: " + e.getMessage());
        }
    }

    /**
     * Stripe Webhook 处理（支付结果回调）
     * @param payload 原始请求体
     * @param sigHeader Stripe-Signature header
     */
    public void handleStripeWebhook(String payload, String sigHeader) {
        try {
            com.stripe.model.Event event = com.stripe.net.Webhook.constructEvent(
                    payload, sigHeader, stripeWebhookSecret
            );
            log.info("Stripe webhook event: {}", event.getType());
            switch (event.getType()) {
                case "payment_intent.succeeded" -> {
                    com.stripe.model.StripeObject stripeObj = event.getDataObjectDeserializer()
                            .getObject().orElse(null);
                    if (stripeObj instanceof PaymentIntent pi) {
                        String orderIdStr = pi.getMetadata().get("orderId");
                        if (orderIdStr != null) {
                            Order order = orderMapper.selectById(Long.parseLong(orderIdStr));
                            if (order != null && "pending".equals(order.getStatus())) {
                                order.setStatus("paid");
                                order.setPaymentMethod("stripe");
                                orderMapper.updateById(order);
                                log.info("Order {} marked as paid", orderIdStr);
                            }
                        }
                    }
                }
                case "payment_intent.payment_failed" -> {
                    log.warn("Payment failed for event: {}", event.getId());
                }
                default -> log.info("Unhandled event type: {}", event.getType());
            }
        } catch (Exception e) {
            log.error("Stripe webhook error: {}", e.getMessage());
            throw new RuntimeException("Webhook processing error: " + e.getMessage());
        }
    }

    /**
     * 创建 PayPal 订单（沙箱）
     * 注：PayPal SDK v2 需要 OAuth token，此处返回结构，真实调用在 Key 配置后生效
     */
    public Map<String, String> createPayPalOrder(Long orderId, Long userId) {
        Order order = getOrderOrThrow(orderId, userId);
        // PayPal SDK 调用占位（待沙箱 Key 配置后激活）
        log.info("Creating PayPal order for orderId={}, amount={}", orderId, order.getTotalAmount());
        Map<String, String> result = new HashMap<>();
        result.put("status", "CREATED");
        result.put("orderId", String.valueOf(orderId));
        result.put("amount", String.valueOf(order.getTotalAmount()));
        result.put("currency", "USD");
        result.put("note", "PayPal sandbox key pending configuration");
        return result;
    }

    /**
     * 捕获 PayPal 支付
     * @param paypalOrderId PayPal 返回的 order ID
     * @param orderId 业务订单 ID
     */
    public Map<String, String> capturePayPalPayment(String paypalOrderId, Long orderId, Long userId) {
        Order order = getOrderOrThrow(orderId, userId);
        // PayPal 捕获逻辑占位（待 Key 配置后激活）
        log.info("Capturing PayPal payment: paypalOrderId={}, orderId={}", paypalOrderId, orderId);
        order.setStatus("paid");
        order.setPaymentMethod("paypal");
        order.setPaymentIntentId(paypalOrderId);
        orderMapper.updateById(order);

        Map<String, String> result = new HashMap<>();
        result.put("status", "COMPLETED");
        result.put("paypalOrderId", paypalOrderId);
        result.put("orderId", String.valueOf(orderId));
        return result;
    }

    private Order getOrderOrThrow(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new RuntimeException("Order not found");
        }
        return order;
    }
}
