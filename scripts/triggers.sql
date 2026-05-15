-- 1. 添加外键约束以保证数据完整性 (如果需要的话，防止孤立评论和点赞)
-- 注意：外键可能会影响删除文章的性能，通常在博客系统里级联删除是合适的。

ALTER TABLE sys_article_like 
ADD CONSTRAINT fk_article_like_article 
FOREIGN KEY (article_id) REFERENCES sys_article(id) ON DELETE CASCADE;

ALTER TABLE sys_comment 
ADD CONSTRAINT fk_comment_article 
FOREIGN KEY (article_id) REFERENCES sys_article(id) ON DELETE CASCADE;

-- 2. 创建触发器，实时同步点赞和浏览量到 article_stat_daily 表

DELIMITER //

DROP TRIGGER IF EXISTS after_article_like_insert //
CREATE TRIGGER after_article_like_insert
AFTER INSERT ON sys_article_like
FOR EACH ROW
BEGIN
    INSERT INTO article_stat_daily (article_id, date, likes_inc, views_inc)
    VALUES (NEW.article_id, CURDATE(), 1, 0)
    ON DUPLICATE KEY UPDATE likes_inc = likes_inc + 1;
END //

DROP TRIGGER IF EXISTS after_article_like_delete //
CREATE TRIGGER after_article_like_delete
AFTER DELETE ON sys_article_like
FOR EACH ROW
BEGIN
    INSERT INTO article_stat_daily (article_id, date, likes_inc, views_inc)
    VALUES (OLD.article_id, CURDATE(), -1, 0)
    ON DUPLICATE KEY UPDATE likes_inc = likes_inc - 1;
END //

DROP TRIGGER IF EXISTS after_article_quantity_update //
CREATE TRIGGER after_article_quantity_update
AFTER UPDATE ON sys_article
FOR EACH ROW
BEGIN
    IF NEW.quantity > OLD.quantity THEN
        INSERT INTO article_stat_daily (article_id, date, likes_inc, views_inc)
        VALUES (NEW.id, CURDATE(), 0, NEW.quantity - OLD.quantity)
        ON DUPLICATE KEY UPDATE views_inc = views_inc + (NEW.quantity - OLD.quantity);
    END IF;
END //

DELIMITER ;
