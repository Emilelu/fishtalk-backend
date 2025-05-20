package org.fishtalk.web.config;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.fishtalk.web.constant.EntityFieldName;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;

/**
 * Mybatis-Plus 配置类
 * 1. 实现自动填充功能
 * 2. 配置分页插件
 * 
 * @author xxl
 * @since 2024/9/13
 */
@Configuration
@Slf4j
public class MybatisPlusConfigure implements MetaObjectHandler {

    /**
     * 插入时自动填充字段
     * 1. 自动填充创建时间
     * 2. 自动填充创建用户
     * 
     * @param metaObject 元对象
     */
    @Override
    public void insertFill(MetaObject metaObject) {
        // 自动填充创建时间
        Object createTime = metaObject.getValue(EntityFieldName.CREATE_TIME);
        if (ObjectUtil.isNull(createTime)) {
            setFieldValByName(EntityFieldName.CREATE_TIME, LocalDateTime.now(), metaObject);
        }

        // 自动填充创建用户
        try {
            Object createUser = metaObject.getValue(EntityFieldName.CREATE_USER);
            if (ObjectUtil.isNull(createUser)) {
                Long userId = StpUtil.getLoginIdAsLong();
                setFieldValByName(EntityFieldName.CREATE_USER, userId, metaObject);
            }
        } catch (Exception e) {
            log.warn("自动填充创建用户失败，可能用户未登录", e);
        }
    }

    /**
     * 更新时自动填充字段
     * 1. 自动填充更新时间
     * 2. 自动填充更新用户
     * 
     * @param metaObject 元对象
     */
    @Override
    public void updateFill(MetaObject metaObject) {
        // 自动填充更新时间
        setFieldValByName(EntityFieldName.UPDATE_TIME, LocalDateTime.now(), metaObject);

        // 自动填充更新用户
        try {
            Long userId = StpUtil.getLoginIdAsLong();
            setFieldValByName(EntityFieldName.UPDATE_USER, userId, metaObject);
        } catch (Exception e) {
            log.warn("自动填充更新用户失败，可能用户未登录", e);
        }
    }

    /**
     * 配置Mybatis-Plus拦截器
     * 1. 添加分页插件
     * 
     * @return MybatisPlusInterceptor 拦截器实例
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 添加分页插件，指定数据库类型为MySQL
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
