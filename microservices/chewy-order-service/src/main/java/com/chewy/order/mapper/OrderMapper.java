package com.chewy.order.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.order.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
