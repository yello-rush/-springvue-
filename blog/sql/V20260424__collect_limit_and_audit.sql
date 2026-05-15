-- 收藏/取消收藏能力增强
-- 目标：
-- 1) 收藏记录支持软状态，保留取消收藏时间戳
-- 2) 增加操作频次计数器
-- 3) 增加用户行为日志表

-- 1. 调整收藏表字段类型与结构
ALTER TABLE `sys_article_collect`
    MODIFY COLUMN `article_id` BIGINT NOT NULL COMMENT '文章id',
    ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '收藏状态:1已收藏,0已取消' AFTER `article_id`,
    ADD COLUMN `operation_count` INT NOT NULL DEFAULT 1 COMMENT '操作累计次数' AFTER `status`,
    ADD COLUMN `last_collect_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '最近收藏时间' AFTER `operation_count`,
    ADD COLUMN `last_uncollect_time` DATETIME NULL COMMENT '最近取消收藏时间' AFTER `last_collect_time`,
    ADD COLUMN `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`;

-- 2. 初始化历史数据
UPDATE `sys_article_collect`
SET `status` = 1,
    `operation_count` = CASE
        WHEN `operation_count` IS NULL OR `operation_count` < 1 THEN 1
        ELSE `operation_count`
    END,
    `last_collect_time` = COALESCE(`last_collect_time`, `create_time`);

-- 3. 索引补齐
ALTER TABLE `sys_article_collect`
    ADD INDEX `idx_user_status_update` (`user_id`, `status`, `update_time`),
    ADD INDEX `idx_article_status` (`article_id`, `status`);

-- 4. 行为日志表（收藏/取消收藏）
CREATE TABLE IF NOT EXISTS `sys_article_collect_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id` INT NOT NULL COMMENT '用户id',
    `article_id` BIGINT NOT NULL COMMENT '文章id',
    `action_type` VARCHAR(20) NOT NULL COMMENT '动作类型:COLLECT/UN_COLLECT',
    `result_code` INT NOT NULL DEFAULT 200 COMMENT '接口返回码',
    `rate_limit_count` INT DEFAULT NULL COMMENT '当前窗口计数',
    `rate_limit_threshold` INT DEFAULT NULL COMMENT '窗口阈值',
    `request_uri` VARCHAR(255) DEFAULT NULL COMMENT '请求URI',
    `client_ip` VARCHAR(64) DEFAULT NULL COMMENT '客户端IP',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_article_time` (`user_id`, `article_id`, `create_time`),
    KEY `idx_action_time` (`action_type`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文章收藏行为日志';
