package org.fishtalk.web.domain.common.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonView;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 实体类
 *
 * @author xxl
 * @since 2024/2/27
 */
@Data
public class Entity implements Serializable {

    @Serial
    private static final long serialVersionUID = -1284347847778673827L;

    @JsonView({UPDATE.class, SaveOrUpdate.class})
    @TableId(type = IdType.AUTO)
    private Long id;

    @JsonView({IGNORE.class})
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @JsonView({IGNORE.class})
    @TableField(fill = FieldFill.UPDATE)
    private LocalDateTime updateTime;
    
    public interface IGNORE {
    }

    public interface UPDATE {
    }

    public interface SaveOrUpdate {
    }
}
