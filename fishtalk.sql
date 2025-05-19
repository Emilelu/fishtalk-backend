-- 创建数据库 (如果不存在)
CREATE DATABASE IF NOT EXISTS `fishtalk` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 选择数据库
USE `fishtalk`;

-- 删除表 (如果已存在，用于清理或重新创建)
-- 注意: 删除表时需要按照外键依赖的顺序进行，从依赖最少的表开始删除
DROP TABLE IF EXISTS `message`;
DROP TABLE IF EXISTS `order`;
DROP TABLE IF EXISTS `product`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `bar`;
DROP TABLE IF EXISTS `user`;

-- 1. 用户表（user）
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `phone` varchar(20) NOT NULL UNIQUE COMMENT '手机号',
  `role` tinyint NOT NULL DEFAULT '0' COMMENT '用户角色，0:普通用户, 1:管理员',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 2. 吧表（bar）
CREATE TABLE `bar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL UNIQUE COMMENT '吧名称',
  `creator_id` bigint(20) NOT NULL COMMENT '创建者ID',
  `member_count` int NOT NULL DEFAULT '0' COMMENT '成员数',
  `post_count` int NOT NULL DEFAULT '0' COMMENT '帖子数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`creator_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='吧表';

-- 3. 帖子表（post）
CREATE TABLE `post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '发帖用户ID',
  `bar_id` bigint(20) NOT NULL COMMENT '所属吧ID',
  `title` varchar(100) NOT NULL COMMENT '帖子标题',
  `content` text NOT NULL COMMENT '帖子内容',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '帖子类型，0:普通帖，1:商品关联帖',
  `is_top` tinyint NOT NULL DEFAULT '0' COMMENT '是否置顶，0:否, 1:是',
  `product_id` bigint(20) NULL COMMENT '如果type=1，关联的商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`bar_id`) REFERENCES `bar` (`id`)
  -- 如果需要确保关联的商品存在，可以添加以下外键约束，但会增加数据插入时的复杂度
  -- FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子表';

-- 4. 商品表（product）
CREATE TABLE `product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '发布用户ID',
  `title` varchar(100) NOT NULL COMMENT '商品标题',
  `description` text NOT NULL COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `stock` int NOT NULL DEFAULT '1' COMMENT '库存',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '商品状态，0:在售, 1:已下架, 2:已售罄',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- 5. 订单表（order）
CREATE TABLE `order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) NOT NULL UNIQUE COMMENT '订单号',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `buyer_id` bigint(20) NOT NULL COMMENT '买家用户ID',
  `seller_id` bigint(20) NOT NULL COMMENT '卖家用户ID',
  `price` decimal(10,2) NOT NULL COMMENT '订单价格',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态，0:待支付，1:已完成，2:已取消',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- 6. 消息表（message）
CREATE TABLE `message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `receiver_id` bigint(20) NOT NULL COMMENT '接收用户ID',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '消息类型，0:系统通知-注册成功, 10:交易通知-支付成功, 11:交易通知-订单取消, ...',
  `content` text NOT NULL COMMENT '消息内容',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '消息状态，0:未读, 1:已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息通知表';

-- 可以选择性添加索引以提高查询性能，例如：
-- CREATE INDEX idx_user_phone ON `user` (`phone`);
-- CREATE INDEX idx_bar_creator ON `bar` (`creator_id`);
-- CREATE INDEX idx_post_bar_user ON `post` (`bar_id`, `user_id`);
-- CREATE INDEX idx_post_create_time ON `post` (`create_time`);
-- CREATE INDEX idx_product_user ON `product` (`user_id`);
-- CREATE INDEX idx_product_status_time ON `product` (`status`, `create_time`);
-- CREATE INDEX idx_order_buyer_seller ON `order` (`buyer_id`, `seller_id`);
-- CREATE INDEX idx_order_create_time ON `order` (`create_time`);
-- CREATE INDEX idx_message_receiver_status ON `message` (`receiver_id`, `status`);