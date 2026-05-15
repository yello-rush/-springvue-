-- ----------------------------
-- Table structure for sys_captcha
-- ----------------------------
DROP TABLE IF EXISTS `sys_captcha`;
CREATE TABLE `sys_captcha` (
  `uuid` varchar(64) NOT NULL COMMENT '唯一标识',
  `code` varchar(10) NOT NULL COMMENT '验证码',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统验证码表';

-- ----------------------------
-- Table structure for sys_user_sign
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_sign`;
CREATE TABLE `sys_user_sign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `sign_date` date NOT NULL COMMENT '签到日期',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '签到时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date` (`user_id`,`sign_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户签到记录表';

-- ----------------------------
-- Table structure for sys_cache (Replacing Redis Key-Value)
-- ----------------------------
DROP TABLE IF EXISTS `sys_cache`;
CREATE TABLE `sys_cache` (
  `cache_key` varchar(191) NOT NULL COMMENT '缓存键',
  `cache_value` longtext COMMENT '缓存值',
  `expire_time` bigint(20) DEFAULT '-1' COMMENT '过期时间(毫秒TS)',
  PRIMARY KEY (`cache_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统缓存表';
