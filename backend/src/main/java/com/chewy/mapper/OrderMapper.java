package com.chewy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
