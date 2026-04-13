package com.chewy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chewy.entity.Category;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CategoryMapper extends BaseMapper<Category> {
}
