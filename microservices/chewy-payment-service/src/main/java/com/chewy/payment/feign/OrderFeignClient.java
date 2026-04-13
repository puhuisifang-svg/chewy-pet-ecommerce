package com.chewy.payment.feign;

import com.chewy.common.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * payment-service → order-service (支付结果回调)
 */
@FeignClient(name = "chewy-order-service", path = "/internal")
public interface OrderFeignClient {
    @PutMapping("/orders/{orderId}/payment-status")
    Result<Void> updatePaymentStatus(
        @PathVariable("orderId") Long orderId,
        @RequestParam("status") String status,
        @RequestParam("paymentIntentId") String paymentIntentId);
}
