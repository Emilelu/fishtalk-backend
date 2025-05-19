package org.fishtalk.web.domain.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.fishtalk.web.domain.common.entity.Entity;

@Data
@TableName("user")
@EqualsAndHashCode(callSuper = true)
public class User extends Entity {
    private String username;
    private String password;
    private String phone;
    private Integer role; // 0:普通用户, 1:管理员
} 