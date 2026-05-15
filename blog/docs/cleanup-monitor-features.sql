-- 监控/定时任务/在线用户功能清理脚本
-- 执行前请先备份数据库

START TRANSACTION;

-- 1) 删除角色与菜单关联
DELETE FROM sys_role_menu
WHERE menu_id IN (
    SELECT id
    FROM sys_menu
    WHERE path LIKE '/monitor%'
       OR component LIKE '/monitor/%'
       OR perm LIKE 'monitor:%'
       OR perm LIKE 'sys:job%'
       OR perm LIKE 'sys:jobLog%'
       OR name IN ('监控中心', '服务监控', '缓存监控', '定时任务', '调度日志', '在线用户')
);

-- 2) 删除监控相关菜单与按钮权限
DELETE FROM sys_menu
WHERE path LIKE '/monitor%'
   OR component LIKE '/monitor/%'
   OR perm LIKE 'monitor:%'
   OR perm LIKE 'sys:job%'
   OR perm LIKE 'sys:jobLog%'
   OR name IN ('监控中心', '服务监控', '缓存监控', '定时任务', '调度日志', '在线用户');

COMMIT;

-- 3) 如确认不再需要历史数据，可手动执行（可选）
-- DROP TABLE IF EXISTS sys_job;
-- DROP TABLE IF EXISTS sys_job_log;
