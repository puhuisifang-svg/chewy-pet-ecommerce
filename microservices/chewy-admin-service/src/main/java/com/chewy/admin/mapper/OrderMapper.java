package com.chewy.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.admin.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
