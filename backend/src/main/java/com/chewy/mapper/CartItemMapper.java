package com.chewy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.entity.CartItem;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CartItemMapper extends BaseMapper<CartItem> {
}
