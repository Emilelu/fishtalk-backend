use fishtalk;
-- ----------------------------
-- 贴鱼项目数据库表结构 SQL 脚本
-- ----------------------------
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
CREATE TABLE `user` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                        `username` varchar(50) NOT NULL COMMENT '用户名',
                        `password` varchar(100) NOT NULL COMMENT '密码（BCrypt加密存储）',
                        `phone` varchar(20) NOT NULL UNIQUE COMMENT '手机号',
                        `email` varchar(50) UNIQUE COMMENT '邮箱',
                        `avatar` varchar(255) COMMENT '头像URL',
                        `credit_score` int(11) NOT NULL DEFAULT '100' COMMENT '信用分（初始100，可增减）',
                        `role` tinyint(4) NOT NULL DEFAULT '0' COMMENT '角色（0:普通用户, 1:吧主, 2:管理员）',
                        `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                        `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:禁用, 1:正常）',
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `uk_username` (`username`),
                        INDEX `idx_credit_score` (`credit_score`),
                        INDEX `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- Table structure for bar
-- ----------------------------
CREATE TABLE `bar` (
                       `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '吧ID',
                       `name` varchar(50) NOT NULL UNIQUE COMMENT '吧名称',
                       `description` varchar(255) COMMENT '吧描述',
                       `avatar` varchar(255) COMMENT '吧头像URL',
                       `creator_id` bigint(20) NOT NULL COMMENT '创建者ID',
                       `member_count` int(11) NOT NULL DEFAULT '0' COMMENT '成员数量',
                       `post_count` int(11) NOT NULL DEFAULT '0' COMMENT '帖子数量',
                       `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                       `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                       `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:禁用, 1:正常）',
                       PRIMARY KEY (`id`),
                       INDEX `idx_creator_id` (`creator_id`),
                       FOREIGN KEY (`creator_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='吧表';

-- ----------------------------
-- Table structure for user_bar
-- ----------------------------
CREATE TABLE `user_bar` (
                            `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
                            `user_id` bigint(20) NOT NULL COMMENT '用户ID',
                            `bar_id` bigint(20) NOT NULL COMMENT '吧ID',
                            `role` tinyint(4) NOT NULL DEFAULT '0' COMMENT '用户角色（0:普通成员, 1:吧主, 2:管理员）',
                            `join_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
                            `last_active_time` datetime COMMENT '最后活跃时间',
                            `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:退出, 1:正常）',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `uk_user_bar` (`user_id`, `bar_id`),
                            INDEX `idx_bar_id` (`bar_id`),
                            INDEX `idx_role_status` (`role`, `status`),
                            FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                            FOREIGN KEY (`bar_id`) REFERENCES `bar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-吧关联表';

-- ----------------------------
-- Table structure for post
-- ----------------------------
CREATE TABLE `post` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
                        `user_id` bigint(20) NOT NULL COMMENT '发布者ID',
                        `bar_id` bigint(20) NOT NULL COMMENT '所属吧ID',
                        `title` varchar(100) NOT NULL COMMENT '标题',
                        `content` text NOT NULL COMMENT '内容',
                        `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型（0:普通帖, 1:商品帖）',
                        `images` varchar(255) COMMENT '图片URL列表（JSON格式）',
                        `view_count` int(11) NOT NULL DEFAULT '0' COMMENT '浏览量',
                        `like_count` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
                        `comment_count` int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
                        `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                        `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:删除, 1:正常）',
                        PRIMARY KEY (`id`),
                        INDEX `idx_user_id_bar_id` (`user_id`, `bar_id`),
                        INDEX `idx_type_status` (`type`, `status`),
                        FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                        FOREIGN KEY (`bar_id`) REFERENCES `bar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子表';

-- ----------------------------
-- Table structure for product
-- ----------------------------
CREATE TABLE `product` (
                           `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
                           `user_id` bigint(20) NOT NULL COMMENT '卖家ID',
                           `title` varchar(100) NOT NULL COMMENT '标题',
                           `description` text NOT NULL COMMENT '描述',
                           `images` varchar(255) COMMENT '图片URL列表（JSON格式）',
                           `price` decimal(10,2) NOT NULL COMMENT '售价',
                           `original_price` decimal(10,2) COMMENT '原价',
                           `stock` int(11) NOT NULL DEFAULT '1' COMMENT '库存',
                           `view_count` int(11) NOT NULL DEFAULT '0' COMMENT '浏览量',
                           `like_count` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
                           `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:下架, 1:上架）',
                           PRIMARY KEY (`id`),
                           INDEX `idx_user_id_status` (`user_id`, `status`),
                           FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- ----------------------------
-- Table structure for order
-- ----------------------------
CREATE TABLE `order` (
                         `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
                         `order_no` varchar(32) NOT NULL UNIQUE COMMENT '订单号（唯一标识）',
                         `product_id` bigint(20) NOT NULL COMMENT '商品ID',
                         `buyer_id` bigint(20) NOT NULL COMMENT '买家ID',
                         `seller_id` bigint(20) NOT NULL COMMENT '卖家ID',
                         `price` decimal(10,2) NOT NULL COMMENT '成交价格',
                         `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（0:待支付, 1:待发货, 2:待收货, 3:已完成, 4:已取消）',
                         `payment_method` tinyint(4) NOT NULL DEFAULT '1' COMMENT '支付方式（1:支付宝, 2:微信支付）',
                         `payment_time` datetime COMMENT '支付时间',
                         `shipping_time` datetime COMMENT '发货时间',
                         `receipt_time` datetime COMMENT '收货时间',
                         `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                         PRIMARY KEY (`id`),
                         INDEX `idx_order_no` (`order_no`),
                         INDEX `idx_buyer_seller_status` (`buyer_id`, `seller_id`, `status`),
                         FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
                         FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                         FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ----------------------------
-- Table structure for comment
-- ----------------------------
CREATE TABLE `comment` (
                           `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
                           `user_id` bigint(20) NOT NULL COMMENT '评论者ID',
                           `target_id` bigint(20) NOT NULL COMMENT '关联对象ID（帖子ID或商品ID）',
                           `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型（0:帖子评论, 1:商品评论）',
                           `parent_id` bigint(20) DEFAULT '0' COMMENT '父评论ID（0表示顶级评论）',
                           `content` text NOT NULL COMMENT '评论内容',
                           `like_count` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
                           `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（0:删除, 1:正常）',
                           PRIMARY KEY (`id`),
                           INDEX `idx_target_id_type` (`target_id`, `type`),
                           INDEX `idx_parent_id` (`parent_id`),
                           FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ----------------------------
-- Table structure for message
-- ----------------------------
CREATE TABLE `message` (
                           `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
                           `receiver_id` bigint(20) NOT NULL COMMENT '接收者ID',
                           `sender_id` bigint(20) DEFAULT '0' COMMENT '发送者ID（系统消息为0）',
                           `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型（0:系统通知, 1:交易通知, 2:社交通知）',
                           `content` text NOT NULL COMMENT '消息内容',
                           `target_id` bigint(20) COMMENT '关联对象ID（订单ID或评论ID）',
                           `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态（0:未读, 1:已读）',
                           `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           PRIMARY KEY (`id`),
                           INDEX `idx_receiver_type_status` (`receiver_id`, `type`, `status`),
                           FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';

-- ----------------------------
-- Table structure for user_like_post
-- ----------------------------
CREATE TABLE `user_like_post` (
                                  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
                                  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
                                  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
                                  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `uk_user_post` (`user_id`, `post_id`),
                                  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                                  FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户点赞帖子表';

-- ----------------------------
-- Table structure for user_like_product
-- ----------------------------
CREATE TABLE `user_like_product` (
                                     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
                                     `user_id` bigint(20) NOT NULL COMMENT '用户ID',
                                     `product_id` bigint(20) NOT NULL COMMENT '商品ID',
                                     `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
                                     PRIMARY KEY (`id`),
                                     UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
                                     FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                                     FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户点赞商品表';

-- ----------------------------
-- Table structure for user_follow
-- ----------------------------
CREATE TABLE `user_follow` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关注ID',
                               `follower_id` bigint(20) NOT NULL COMMENT '关注者ID',
                               `followed_id` bigint(20) NOT NULL COMMENT '被关注者ID',
                               `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_follower_followed` (`follower_id`, `followed_id`),
                               FOREIGN KEY (`follower_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
                               FOREIGN KEY (`followed_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注表';

SET FOREIGN_KEY_CHECKS = 1;