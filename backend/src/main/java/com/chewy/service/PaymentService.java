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

    @Value("${payment.paypal.client-id:#{null}}")
    private String paypalClientId;

    @Value("${payment.paypal.client-secret:#{null}}")
    private String paypalClientSecret;

    @Value("${payment.paypal.mode:sandbox}")
    private String paypalMode;

    @Value("${payment.paypal.enabled:false}")
    private boolean paypalEnabled;

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
     * 创建 PayPal 订单（暂未开放，Key 待配置）
     */
    public Map<String, String> createPayPalOrder(Long orderId, Long userId) {
        if (!paypalEnabled) {
            Map<String, String> result = new HashMap<>();
            result.put("status", "UNAVAILABLE");
            result.put("message", "PayPal payment is not available yet. Please use Stripe.");
            return result;
        }
        // PayPal SDK 调用（待 Key 配置后激活）
        getOrderOrThrow(orderId, userId);
        log.info("PayPal createOrder placeholder: orderId={}", orderId);
        Map<String, String> result = new HashMap<>();
        result.put("status", "CREATED");
        result.put("orderId", String.valueOf(orderId));
        result.put("note", "PayPal sandbox key pending configuration");
        return result;
    }

    /**
     * 捕获 PayPal 支付（暂未开放）
     */
    public Map<String, String> capturePayPalPayment(String paypalOrderId, Long orderId, Long userId) {
        if (!paypalEnabled) {
            Map<String, String> result = new HashMap<>();
            result.put("status", "UNAVAILABLE");
            result.put("message", "PayPal payment is not available yet. Please use Stripe.");
            return result;
        }
        // PayPal 捕获逻辑（待 Key 配置后激活）
        getOrderOrThrow(orderId, userId);
        log.info("PayPal capture placeholder: paypalOrderId={}, orderId={}", paypalOrderId, orderId);
        Map<String, String> result = new HashMap<>();
        result.put("status", "PENDING_CONFIGURATION");
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
