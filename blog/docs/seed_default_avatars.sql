-- 创建预置的图库（如果不存在）
INSERT INTO sys_album (cover, name, description, isLock, password, sort, create_time)
SELECT '/gallery/avatar-lib-1.jpg', '默认头像库', '系统默认头像库', 0, NULL, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_album WHERE name = '默认头像库');

INSERT INTO sys_album (cover, name, description, isLock, password, sort, create_time)
SELECT '/gallery/avatar-lib-1.jpg', '用户头像库', '用户上传头像库', 0, NULL, 2, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_album WHERE name = '用户头像库');

INSERT INTO sys_album (cover, name, description, isLock, password, sort, create_time)
SELECT '/gallery/avatar-lib-1.jpg', '管理员图片库', '管理员使用的图片资源库', 0, NULL, 3, NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_album WHERE name = '管理员图片库');

-- 记录默认头像库 ID
SET @default_album_id := (SELECT id FROM sys_album WHERE name = '默认头像库' LIMIT 1);

-- 写入10张默认头像到 sys_photo（若已存在则跳过）
INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-1.jpg', '默认头像1', 1, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-1.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-2.jpg', '默认头像2', 2, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-2.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-3.jpg', '默认头像3', 3, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-3.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-4.jpg', '默认头像4', 4, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-4.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-5.jpg', '默认头像5', 5, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-5.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-6.jpg', '默认头像6', 6, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-6.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-7.jpg', '默认头像7', 7, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-7.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-8.jpg', '默认头像8', 8, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-8.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-9.jpg', '默认头像9', 9, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-9.jpg');

INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time)
SELECT @default_album_id, '/gallery/avatar-lib-10.jpg', '默认头像10', 10, CURDATE(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM sys_photo WHERE album_id = @default_album_id AND url = '/gallery/avatar-lib-10.jpg');

-- 将缺失头像的用户按 id 均匀分配默认头像库中的图片
SET @photo_cnt := (SELECT COUNT(*) FROM sys_photo WHERE album_id = @default_album_id);
UPDATE sys_user u
SET u.avatar = (
  SELECT p.url
  FROM sys_photo p
  WHERE p.album_id = @default_album_id
  ORDER BY p.id
  LIMIT (u.id % @photo_cnt), 1
)
WHERE (u.avatar IS NULL OR u.avatar = '');
