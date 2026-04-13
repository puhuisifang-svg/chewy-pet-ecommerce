package com.chewy.dto.order;

import com.chewy.entity.Order;
import com.chewy.entity.OrderItem;
import lombok.Data;
import java.util.List;

@Data
public class OrderDetailVO {
    private Order order;
    private List<OrderItem> items;
}
