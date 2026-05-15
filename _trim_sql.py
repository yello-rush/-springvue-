from pathlib import Path

src = Path(r"e:\桌面\blog_optimized.sql")
out = Path(r"e:\桌面\blog_optimized.sql")
text = src.read_text(encoding="utf-8", errors="ignore")
lines = text.splitlines()

# 保留主要表
keep = [
    'sys_user','sys_role','sys_menu','sys_user_role','sys_role_menu',
    'sys_category','sys_tag','sys_article','sys_article_tag','sys_comment','sys_notifications'
]
keep_set = set(keep)

result = []
result.append('-- Core schema (main tables only)')
result.append('SET NAMES utf8mb4;')
result.append('SET FOREIGN_KEY_CHECKS = 0;')
result.append('')

i = 0
n = len(lines)
while i < n:
    line = lines[i]
    if line.startswith('DROP TABLE IF EXISTS '):
        # next create block may follow
        name = None
        if '`' in line:
            ps = line.split('`')
            if len(ps) >= 2:
                name = ps[1]
        if name in keep_set:
            # append DROP
            result.append(line)
            # seek create table line
            i += 1
            while i < n and not lines[i].startswith('CREATE TABLE '):
                i += 1
            if i < n and lines[i].startswith('CREATE TABLE '):
                result.append(lines[i])
                i += 1
                while i < n:
                    result.append(lines[i])
                    if 'ENGINE=' in lines[i] and lines[i].strip().endswith(';'):
                        result.append('')
                        break
                    i += 1
        else:
            # skip this block naturally
            pass
    i += 1

result.append('SET FOREIGN_KEY_CHECKS = 1;')
out.write_text('\n'.join(result) + '\n', encoding='utf-8')
print(out)
print('tables_kept=', len(keep))
