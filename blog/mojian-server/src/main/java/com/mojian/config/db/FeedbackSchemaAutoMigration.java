package com.mojian.config.db;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * 自动修复反馈表字段，兼容旧版库结构。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class FeedbackSchemaAutoMigration implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        try {
            migrate();
        } catch (Exception ex) {
            log.warn("反馈表结构自动修复失败，请手动执行 migration SQL：{}", ex.getMessage());
        }
    }

    private void migrate() {
        if (!tableExists("sys_feedback")) {
            return;
        }

        boolean hasFeedbackType = columnExists("sys_feedback", "feedback_type");
        boolean hasLegacyType = columnExists("sys_feedback", "type");

        if (!hasFeedbackType) {
            jdbcTemplate.execute(
                    "ALTER TABLE `sys_feedback` " +
                            "ADD COLUMN `feedback_type` VARCHAR(32) NOT NULL DEFAULT 'function_suggestion' COMMENT '反馈类型'"
            );
            hasFeedbackType = true;
            log.info("已自动补齐字段: sys_feedback.feedback_type");
        }

        if (hasFeedbackType && hasLegacyType) {
            jdbcTemplate.execute(
                    "UPDATE `sys_feedback` " +
                            "SET `feedback_type` = CASE `type` " +
                            "WHEN '1' THEN 'bug_report' " +
                            "WHEN '2' THEN 'function_suggestion' " +
                            "WHEN '3' THEN 'performance_issue' " +
                            "WHEN '4' THEN 'ui_optimization' " +
                            "ELSE 'other' END " +
                            "WHERE `feedback_type` IS NULL OR `feedback_type` = ''"
            );
            log.info("已自动完成旧字段 type -> feedback_type 数据迁移");
            jdbcTemplate.execute(
                    "UPDATE `sys_feedback` SET `type` = '2' " +
                            "WHERE `type` IS NULL OR `type` = ''"
            );
            try {
                jdbcTemplate.execute("ALTER TABLE `sys_feedback` ALTER COLUMN `type` SET DEFAULT '2'");
            } catch (Exception ignored) {
                // 兼容不同 MySQL 方言，不影响主流程
            }
        }

        // 兜底清洗非法值，避免枚举校验失败
        jdbcTemplate.execute(
                "UPDATE `sys_feedback` " +
                        "SET `feedback_type` = 'other' " +
                        "WHERE `feedback_type` NOT IN ('function_suggestion','bug_report','performance_issue','ui_optimization','other')"
        );

        if (!indexExists("sys_feedback", "idx_feedback_type")) {
            jdbcTemplate.execute("ALTER TABLE `sys_feedback` ADD INDEX `idx_feedback_type` (`feedback_type`)");
            log.info("已自动补齐索引: idx_feedback_type");
        }
    }

    private boolean tableExists(String tableName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM information_schema.tables " +
                        "WHERE table_schema = DATABASE() AND table_name = ?",
                Integer.class,
                tableName
        );
        return count != null && count > 0;
    }

    private boolean columnExists(String tableName, String columnName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM information_schema.columns " +
                        "WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?",
                Integer.class,
                tableName,
                columnName
        );
        return count != null && count > 0;
    }

    private boolean indexExists(String tableName, String indexName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM information_schema.statistics " +
                        "WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?",
                Integer.class,
                tableName,
                indexName
        );
        return count != null && count > 0;
    }
}
