package org.fishtalk.web.domain.user.controller;

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

import java.util.HashMap;
import java.util.Map;

/**
 * 用户管理控制器
 * 提供用户注册、登录、信息修改等接口
 */
@Tag(name = "用户管理", description = "用户注册、登录、信息修改等接口")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    /**
     * 用户注册
     *
     * @param registerDTO 注册信息DTO，包含手机号和密码
     * @return 注册成功的用户信息
     */
    @Operation(summary = "用户注册", description = "通过手机号和密码注册新用户")
    @PostMapping("/register")
    public RespEntity<User> register(@RequestBody RegisterDTO registerDTO) {
        // 检查是否已登录
        if (StpUtil.isLogin()) {
            return RespEntity.fail("已登录用户不能注册新账号");
        }
        // 调用服务层进行注册
        User user = userService.register(registerDTO.getPhone(), registerDTO.getPassword());
        return RespEntity.success(user);
    }

    /**
     * 用户登录
     *
     * @param loginDTO 登录信息DTO，包含手机号和密码
     * @return 包含用户信息和token的响应
     */
    @Operation(summary = "用户登录", description = "通过手机号和密码登录")
    @PostMapping("/login")
    public RespEntity<Object> login(@RequestBody LoginDTO loginDTO) {
        // 调用服务层进行登录
        User user = userService.login(loginDTO.getPhone(), loginDTO.getPassword());
        // 返回用户信息和token
        Map<String, Object> map = new HashMap<>();
        map.put("user", user);
        map.put("token", StpUtil.getTokenValue());
        return RespEntity.success(map);
    }

    /**
     * 修改用户名
     *
     * @param updateUsernameDTO 用户名修改信息DTO
     * @return 操作结果
     */
    @Operation(summary = "修改用户名", description = "修改用户的用户名")
    @PostMapping("/updateUsername")
    public RespEntity<Void> updateUsername(@RequestBody UpdateUsernameDTO updateUsernameDTO) {
        // 从SaToken中获取当前用户ID
        Long userId = StpUtil.getLoginIdAsLong();
        // 调用服务层更新用户名
        userService.updateUsername(userId, updateUsernameDTO.getNewUsername());
        return RespEntity.success();
    }

    /**
     * 修改手机号
     *
     * @param updatePhoneDTO 手机号修改信息DTO
     * @return 操作结果
     */
    @Operation(summary = "修改手机号", description = "修改用户的手机号")
    @PostMapping("/updatePhone")
    public RespEntity<Void> updatePhone(@RequestBody UpdatePhoneDTO updatePhoneDTO) {
        // 从SaToken中获取当前用户ID
        Long userId = StpUtil.getLoginIdAsLong();
        // 调用服务层更新手机号
        userService.updatePhone(userId, updatePhoneDTO.getNewPhone());
        return RespEntity.success();
    }

    /**
     * 修改密码
     *
     * @param updatePasswordDTO 密码修改信息DTO
     * @return 操作结果
     */
    @Operation(summary = "修改密码", description = "修改用户的密码")
    @PostMapping("/updatePassword")
    public RespEntity<Void> updatePassword(@RequestBody UpdatePasswordDTO updatePasswordDTO) {
        // 从SaToken中获取当前用户ID
        Long userId = StpUtil.getLoginIdAsLong();
        // 调用服务层更新密码
        userService.updatePassword(userId, updatePasswordDTO.getOldPassword(), updatePasswordDTO.getNewPassword());
        return RespEntity.success();
    }

    /**
     * 重置密码
     *
     * @param resetPasswordDTO 密码重置信息DTO
     * @return 操作结果
     */
    @Operation(summary = "重置密码", description = "通过手机号重置密码")
    @PostMapping("/resetPassword")
    public RespEntity<Void> resetPassword(@RequestBody ResetPasswordDTO resetPasswordDTO) {
        // 调用服务层重置密码
        userService.resetPassword(resetPasswordDTO.getPhone(), resetPasswordDTO.getNewPassword());
        return RespEntity.success();
    }
} 