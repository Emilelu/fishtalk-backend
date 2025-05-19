package org.fishtalk.web.domain.user.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.fishtalk.sdk.resp.RespEntity;
import org.fishtalk.web.domain.user.dto.*;
import org.fishtalk.web.domain.user.entity.User;
import org.fishtalk.web.domain.user.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "用户管理", description = "用户注册、登录、信息修改等接口")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    @Operation(summary = "用户注册", description = "通过手机号和密码注册新用户")
    @PostMapping("/register")
    public RespEntity<User> register(@RequestBody RegisterDTO registerDTO) {
        if (StpUtil.isLogin()) {
            return RespEntity.fail("已登录用户不能注册新账号");
        }
        User user = userService.register(registerDTO.getPhone(), registerDTO.getPassword());
        return RespEntity.success(user);
    }

    @Operation(summary = "用户登录", description = "通过手机号和密码登录")
    @PostMapping("/login")
    public RespEntity<User> login(@RequestBody LoginDTO loginDTO) {
        User user = userService.login(loginDTO.getPhone(), loginDTO.getPassword());
        return RespEntity.success(user);
    }

    @Operation(summary = "修改用户名", description = "修改用户的用户名")
    @SaCheckLogin
    @PostMapping("/updateUsername")
    public RespEntity<Void> updateUsername(@RequestBody UpdateUsernameDTO updateUsernameDTO) {
        userService.updateUsername(updateUsernameDTO.getUserId(), updateUsernameDTO.getNewUsername());
        return RespEntity.success();
    }

    @Operation(summary = "修改手机号", description = "修改用户的手机号")
    @SaCheckLogin
    @PostMapping("/updatePhone")
    public RespEntity<Void> updatePhone(@RequestBody UpdatePhoneDTO updatePhoneDTO) {
        userService.updatePhone(updatePhoneDTO.getUserId(), updatePhoneDTO.getNewPhone());
        return RespEntity.success();
    }

    @Operation(summary = "修改密码", description = "修改用户的密码")
    @SaCheckLogin
    @PostMapping("/updatePassword")
    public RespEntity<Void> updatePassword(@RequestBody UpdatePasswordDTO updatePasswordDTO) {
        userService.updatePassword(updatePasswordDTO.getUserId(), updatePasswordDTO.getOldPassword(), updatePasswordDTO.getNewPassword());
        return RespEntity.success();
    }

    @Operation(summary = "重置密码", description = "通过手机号重置密码")
    @PostMapping("/resetPassword")
    public RespEntity<Void> resetPassword(@RequestBody ResetPasswordDTO resetPasswordDTO) {
        userService.resetPassword(resetPasswordDTO.getPhone(), resetPasswordDTO.getNewPassword());
        return RespEntity.success();
    }
} 