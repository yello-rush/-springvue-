CREATE TABLE IF NOT EXISTS `sys_article_collect`
(
    `id`         int NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`    int NOT NULL COMMENT '用户id',
    `article_id` int NOT NULL COMMENT '文章id',
    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_user_article`(`user_id`, `article_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COMMENT = '文章收藏表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `sys_user_article_history`
(
    `id`         int NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`    int NOT NULL COMMENT '用户id',
    `article_id` int NOT NULL COMMENT '文章id',
    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_user_article`(`user_id`, `article_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COMMENT = '用户浏览历史表' ROW_FORMAT = Dynamic;
