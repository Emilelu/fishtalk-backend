package org.fishtalk.web.domain.user.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.digest.DigestUtil;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import lombok.RequiredArgsConstructor;
import org.fishtalk.sdk.exception.ServiceException;
import org.fishtalk.web.domain.user.entity.User;
import org.fishtalk.web.domain.user.mapper.UserMapper;
import org.fishtalk.web.domain.user.service.UserService;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    @Override
    public User register(String phone, String password) {
        // 检查手机号是否已注册
        if (userMapper.selectCount(new QueryWrapper<User>().eq("phone", phone)) > 0) {
            throw new ServiceException("手机号已注册");
        }

        // 创建用户
        User user = new User();
        user.setPhone(phone);
        user.setPassword(DigestUtil.bcrypt(password));
        user.setUsername("用户" + System.currentTimeMillis());
        user.setRole(0); // 默认普通用户
        userMapper.insert(user);
        return user;
    }

    @Override
    public User login(String phone, String password) {
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("phone", phone));
        if (user == null || !DigestUtil.bcryptCheck(password, user.getPassword())) {
            throw new ServiceException("手机号或密码错误");
        }

        // 登录
        StpUtil.login(user.getId());
        return user;
    }

    @Override
    public void updateUsername(Long userId, String newUsername) {
        if (StrUtil.isBlank(newUsername)) {
            throw new ServiceException("用户名不能为空");
        }
        User user = new User();
        user.setId(userId);
        user.setUsername(newUsername);
        userMapper.updateById(user);
    }

    @Override
    public void updatePhone(Long userId, String newPhone) {
        if (StrUtil.isBlank(newPhone)) {
            throw new ServiceException("手机号不能为空");
        }
        if (userMapper.selectCount(new QueryWrapper<User>().eq("phone", newPhone)) > 0) {
            throw new ServiceException("手机号已被使用");
        }
        User user = new User();
        user.setId(userId);
        user.setPhone(newPhone);
        userMapper.updateById(user);
    }

    @Override
    public void updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = userMapper.selectById(userId);
        if (!DigestUtil.bcryptCheck(oldPassword, user.getPassword())) {
            throw new ServiceException("原密码错误");
        }
        user.setPassword(DigestUtil.bcrypt(newPassword));
        userMapper.updateById(user);
    }

    @Override
    public void resetPassword(String phone, String newPassword) {
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("phone", phone));
        if (user == null) {
            throw new ServiceException("手机号未注册");
        }
        user.setPassword(DigestUtil.bcrypt(newPassword));
        userMapper.updateById(user);
    }

    @Override
    public boolean saveBatch(Collection<User> entityList, int batchSize) {
        return false;
    }

    @Override
    public boolean saveOrUpdateBatch(Collection<User> entityList, int batchSize) {
        return false;
    }

    @Override
    public boolean updateBatchById(Collection<User> entityList, int batchSize) {
        return false;
    }

    @Override
    public boolean saveOrUpdate(User entity) {
        return false;
    }

    @Override
    public User getOne(Wrapper<User> queryWrapper, boolean throwEx) {
        return null;
    }

    @Override
    public Optional<User> getOneOpt(Wrapper<User> queryWrapper, boolean throwEx) {
        return Optional.empty();
    }

    @Override
    public Map<String, Object> getMap(Wrapper<User> queryWrapper) {
        return Map.of();
    }

    @Override
    public <V> V getObj(Wrapper<User> queryWrapper, Function<? super Object, V> mapper) {
        return null;
    }

    @Override
    public BaseMapper<User> getBaseMapper() {
        return null;
    }

    @Override
    public Class<User> getEntityClass() {
        return null;
    }
}