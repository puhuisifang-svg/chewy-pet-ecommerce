package com.chewy.user.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("users")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String email;
    // 注意：select=false 会导致 login 时查不到密码，登录接口需手动查或改用自定义SQL
    // 这里去掉 select=false，密码字段正常查询（序列化时由 @JsonIgnore 屏蔽输出）
    @com.fasterxml.jackson.annotation.JsonIgnore
    private String password;
    private String username;
    private String firstName;
    private String lastName;
    private String phone;
    private String avatar;
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
