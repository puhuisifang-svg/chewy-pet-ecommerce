package com.chewy.cart.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.cart.entity.Product;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {
}
