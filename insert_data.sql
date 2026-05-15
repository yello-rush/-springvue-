-- 插入标签数据
INSERT INTO sys_tag (id, name, click_volume, sort, create_time, update_time) VALUES 
(1, 'Java', 100, 1, NOW(), NOW()),
(2, 'Spring Boot', 90, 2, NOW(), NOW()),
(3, 'Vue.js', 85, 3, NOW(), NOW()),
(4, 'MySQL', 70, 4, NOW(), NOW()),
(5, 'Redis', 60, 5, NOW(), NOW()),
(6, 'Docker', 55, 6, NOW(), NOW());

-- 插入分类数据
INSERT INTO sys_category (id, name, click_volume, sort, create_time, update_time) VALUES
(1, '后端开发', 200, 1, NOW(), NOW()),
(2, '前端开发', 180, 2, NOW(), NOW()),
(3, '数据库', 150, 3, NOW(), NOW()),
(4, '运维部署', 120, 4, NOW(), NOW());

-- 插入文章数据 (关联分类ID)
-- 示例文章 1
INSERT INTO sys_article (user_id, category_id, title, avatar, summary, content, content_md, is_original, is_publish, create_time, update_time, quantity)
VALUES (1, 1, '深入理解Spring Boot自动配置原理', 'https://img.shiyit.com/base/1685025737512.jpg', 'Spring Boot自动配置是其核心特性之一，本文将带你深入源码分析其实现原理。', '<h1>Spring Boot自动配置原理</h1><p>内容详情...</p>', '# Spring Boot自动配置原理\n内容详情...', 1, 1, NOW(), NOW(), 100);

-- 示例文章 2
INSERT INTO sys_article (user_id, category_id, title, avatar, summary, content, content_md, is_original, is_publish, create_time, update_time, quantity)
VALUES (1, 2, 'Vue3 Composition API 实战指南', 'https://img.shiyit.com/base/1685025785055.jpg', 'Vue3带来了全新的Composition API，如何优雅地使用它？', '<h1>Vue3 Composition API</h1><p>内容详情...</p>', '# Vue3 Composition API\n内容详情...', 1, 1, NOW(), NOW(), 88);

-- 示例文章 3
INSERT INTO sys_article (user_id, category_id, title, avatar, summary, content, content_md, is_original, is_publish, create_time, update_time, quantity)
VALUES (1, 3, 'MySQL索引优化实战', 'https://img.shiyit.com/base/1685025812345.jpg', '从B+树结构讲起，带你掌握MySQL索引优化的核心技巧。', '<h1>MySQL索引优化</h1><p>内容详情...</p>', '# MySQL索引优化\n内容详情...', 1, 1, NOW(), NOW(), 150);

-- 插入文章-标签关联
INSERT INTO sys_article_tag (article_id, tag_id) VALUES
(1, 1), (1, 2), -- 文章1 关联 Java, Spring Boot
(2, 3),         -- 文章2 关联 Vue.js
(3, 4);         -- 文章3 关联 MySQL
