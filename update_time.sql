SET @start_time = UNIX_TIMESTAMP('2026-03-01 00:00:00');
SET @end_time = UNIX_TIMESTAMP('2026-04-30 23:59:59');

UPDATE sys_article SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_comment SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_user SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_feedback SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_message SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_moment SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_notifications SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_operate_log SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_photo SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
UPDATE sys_article_history SET create_time = FROM_UNIXTIME(@start_time + FLOOR(RAND() * (@end_time - @start_time)));
