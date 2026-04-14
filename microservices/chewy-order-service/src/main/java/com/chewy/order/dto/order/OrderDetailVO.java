package com.chewy.order.dto.order;

import com.chewy.order.entity.Order;
import com.chewy.order.entity.OrderItem;
import lombok.Data;
import java.util.List;

@Data
public class OrderDetailVO {
    private Order order;
    private List<OrderItem> items;
}
