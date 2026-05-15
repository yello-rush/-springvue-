-- 将旧版sys_feedback.type迁移为sys_feedback.feedback_type（枚举）
ALTER TABLE `sys_feedback`
    ADD COLUMN `feedback_type` ENUM('function_suggestion', 'bug_report', 'performance_issue', 'ui_optimization', 'other')
    NOT NULL DEFAULT 'function_suggestion' COMMENT '反馈类型' AFTER `user_id`;

UPDATE `sys_feedback`
SET `feedback_type` = CASE `type`
    WHEN 'function_suggestion' THEN 'function_suggestion'
    WHEN 'bug_report' THEN 'bug_report'
    WHEN 'performance_issue' THEN 'performance_issue'
    WHEN 'ui_optimization' THEN 'ui_optimization'
    WHEN 'other' THEN 'other'
    ELSE 'other'
END;

ALTER TABLE `sys_feedback`
    ADD INDEX `idx_feedback_type` (`feedback_type`);

ALTER TABLE `sys_feedback`
    DROP COLUMN `type`;
