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
 * @author xxl
 * @since 2024/9/13
 */
@Configuration
@Slf4j
public class MybatisPlusConfigure implements MetaObjectHandler {

    /**
     * mybatis-plus自动填充功能实现
     *
     * @param metaObject 元对象
     */
    @Override
    public void insertFill(MetaObject metaObject) {
        //为空则设置deleteFlag
        Object deleteFlag = metaObject.getValue(EntityFieldName.DELETE_FLAG);
        if (ObjectUtil.isNull(deleteFlag)) {
            setFieldValByName(EntityFieldName.DELETE_FLAG, EntityFieldName.DELETE_FLAG_N, metaObject);
        }

        //为空则设置createTime
        Object createTime = metaObject.getValue(EntityFieldName.CREATE_TIME);
        if (ObjectUtil.isNull(createTime)) {
            setFieldValByName(EntityFieldName.CREATE_TIME, LocalDateTime.now(), metaObject);
        }

        try {
            //为空则设置createUser
            Object createUser = metaObject.getValue(EntityFieldName.CREATE_USER);
            if (ObjectUtil.isNull(createUser)) {
                setFieldValByName(EntityFieldName.CREATE_USER, StpUtil.getLoginId(), metaObject);
            }
        } catch (Exception e) {
            //log.error("自动填充实体类createUser属性值失败: ", e);
        }
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        try {
            setFieldValByName(EntityFieldName.UPDATE_USER, StpUtil.getLoginId(), metaObject);
        } catch (Exception e) {
            log.error("自动填充实体类updateUser属性值失败: ", e);
        }
        setFieldValByName(EntityFieldName.UPDATE_TIME, LocalDateTime.now(), metaObject);
    }

    /**
     * Mybatis添加分页插件
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
