package org.fishtalk.web.domain.user.service;

import org.fishtalk.web.domain.common.service.IBaseService;
import org.fishtalk.web.domain.user.entity.User;

public interface UserService extends IBaseService<User> {
    // 注册
    User register(String phone, String password);

    // 登录
    User login(String phone, String password);

    // 修改用户名
    void updateUsername(Long userId, String newUsername);

    // 修改手机号
    void updatePhone(Long userId, String newPhone);

    // 修改密码
    void updatePassword(Long userId, String oldPassword, String newPassword);

    // 通过手机号找回密码
    void resetPassword(String phone, String newPassword);
} 