-- 增加时间字段
ALTER TABLE sys_article ADD COLUMN first_accessed_time DATETIME DEFAULT NULL COMMENT '首次被访问时间';
ALTER TABLE sys_article ADD COLUMN last_accessed_time DATETIME DEFAULT NULL COMMENT '最后访问时间';
ALTER TABLE sys_article ADD COLUMN heat_score DOUBLE DEFAULT 0 COMMENT '热度分数';
CREATE TABLE IF NOT EXISTS article_stat_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id BIGINT,
    date DATE,
    likes_inc INT DEFAULT 0,
    views_inc INT DEFAULT 0,
    UNIQUE KEY idx_article_date (article_id, date)
) COMMENT '文章日统计表';

-- 回滚语句
-- ALTER TABLE sys_article DROP COLUMN first_accessed_time;
-- ALTER TABLE sys_article DROP COLUMN last_accessed_time;
-- ALTER TABLE sys_article DROP COLUMN heat_score;
-- DROP TABLE article_stat_daily;
