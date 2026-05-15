import re
from pathlib import Path

src = Path(r"e:\桌面\shiyi-blog-master\blog.sql")
out = Path(r"e:\桌面\blog_optimized.sql")
text = src.read_text(encoding="utf-8", errors="ignore")
lines = text.splitlines()

# short comments (<=4汉字)
col_map = {
    'id':'主键','user_id':'用户','role_id':'角色','menu_id':'菜单','article_id':'文章','category_id':'分类','tag_id':'标签',
    'parent_id':'上级','reply_user_id':'回者','username':'账号','password':'密码','nickname':'昵称','avatar':'头像','email':'邮箱',
    'mobile':'手机','status':'状态','create_time':'创建','update_time':'更新','last_login_time':'末登','ip':'IP','ip_location':'IP源',
    'os':'系统','browser':'浏览','sex':'性别','login_type':'登录','security_code':'安码','signature':'签名','code':'编码','name':'名称',
    'remarks':'备注','path':'路径','component':'组件','title':'标题','sort':'排序','icon':'图标','type':'类型','redirect':'重定',
    'hidden':'隐藏','perm':'权限','is_external':'外链','cover':'封面','summary':'摘要','content':'内容','content_md':'正文MD',
    'read_type':'阅读','is_stick':'置顶','is_carousel':'轮播','is_recommend':'推荐','quantity':'阅读量','keywords':'关键词',
    'ai_describe':'AI述','heat_score':'热度','first_accessed_time':'首访','last_accessed_time':'末访','favorite_num':'收藏数',
    'like_count':'点赞数','is_read':'已读','from_user_id':'来源用户','message':'消息','link':'链接','feedback_type':'反馈类',
    'reply_content':'回复','sign_date':'签到日','job_id':'任务','job_name':'任务名','job_group':'任务组','invoke_target':'调用',
    'cron_expression':'表达式','misfire_policy':'错策','concurrent':'并发','remark':'备注','job_message':'日志','exception_info':'异常',
    'start_time':'开始','stop_time':'结束','url':'地址','size':'大小','filename':'文件名','original_filename':'原名',
    'base_path':'基路','ext':'扩展','content_type':'类型','platform':'平台','source':'来源'
}

table_map = {
    'sys_user':'用户表','sys_role':'角色表','sys_menu':'菜单表','sys_user_role':'用户角色','sys_role_menu':'角色菜单',
    'sys_category':'分类表','sys_tag':'标签表','sys_article':'文章表','sys_article_tag':'文章标签','sys_comment':'评论表',
    'sys_notifications':'通知表','sys_message':'留言表','sys_feedback':'反馈表','sys_user_sign':'签到表',
    'sys_job':'任务表','sys_job_log':'任务日志','file_detail':'文件表'
}

def short_comment(s, fallback='字段'):
    if s and s.strip():
        txt = s.strip().strip("'")
        # keep chinese chars first
        zh = ''.join(ch for ch in txt if '\u4e00' <= ch <= '\u9fff')
        if zh:
            return zh[:4]
        return txt[:4]
    return fallback

# relations: (table, col, ref_table, ref_col, verb)
relations = [
    ('sys_user_role','user_id','sys_user','id','隶属于'),
    ('sys_user_role','role_id','sys_role','id','授予'),
    ('sys_role_menu','role_id','sys_role','id','绑定'),
    ('sys_role_menu','menu_id','sys_menu','id','授权'),
    ('sys_article','user_id','sys_user','id','发布'),
    ('sys_article','category_id','sys_category','id','归类'),
    ('sys_article_tag','article_id','sys_article','id','标注'),
    ('sys_article_tag','tag_id','sys_tag','id','归属'),
    ('sys_comment','article_id','sys_article','id','评论于'),
    ('sys_comment','user_id','sys_user','id','发表'),
    ('sys_comment','reply_user_id','sys_user','id','回复'),
    ('sys_comment','parent_id','sys_comment','id','从属'),
    ('sys_notifications','user_id','sys_user','id','通知'),
    ('sys_notifications','from_user_id','sys_user','id','来源'),
    ('sys_notifications','article_id','sys_article','id','关联'),
    ('sys_feedback','user_id','sys_user','id','提交'),
]

# index relation map
rel_map = {}
for r in relations:
    rel_map.setdefault(r[0], []).append(r)

out_lines = []
i = 0
n = len(lines)
while i < n:
    line = lines[i]
    if line.startswith('CREATE TABLE '):
        # capture create block until ENGINE line
        block = [line]
        i += 1
        while i < n:
            block.append(lines[i])
            if 'ENGINE=' in lines[i] and lines[i].strip().endswith(';'):
                break
            i += 1

        first = block[0]
        mtn = re.search(r'CREATE TABLE\s+`([^`]+)`', first)
        table = mtn.group(1) if mtn else None

        # process body lines (between first and last)
        if table and len(block) >= 2:
            body = block[1:-1]
            end = block[-1]

            new_body = []
            for b in body:
                cm = re.match(r"\s*`([^`]+)`\s+(.*)", b)
                if cm:
                    col = cm.group(1)
                    # set comment
                    pref = col_map.get(col, short_comment('', '字段'))
                    if 'COMMENT' in b:
                        b = re.sub(r"COMMENT\s+'[^']*'", f"COMMENT '{pref}'", b)
                    else:
                        # add before trailing comma if exists
                        if b.rstrip().endswith(','):
                            b = b.rstrip()[:-1] + f" COMMENT '{pref}',"
                        else:
                            b = b.rstrip() + f" COMMENT '{pref}'"
                new_body.append(b)

            body_text = '\n'.join(new_body)

            # add missing foreign keys
            add_fk = []
            for (t, col, rt, rc, verb) in rel_map.get(table, []):
                pat = rf"FOREIGN KEY\s*\(`{re.escape(col)}`\)\s*REFERENCES\s*`?{re.escape(rt)}`?\s*\(`{re.escape(rc)}`\)"
                if not re.search(pat, body_text):
                    fk_name = f"fk_{table}_{col}"
                    add_fk.append(f"  CONSTRAINT `{fk_name}` FOREIGN KEY (`{col}`) REFERENCES `{rt}`(`{rc}`) /*{verb}*/")

            if add_fk:
                # ensure last existing body line has comma
                if new_body:
                    last = new_body[-1].rstrip()
                    if not last.endswith(','):
                        new_body[-1] = new_body[-1] + ','
                for idx, fk in enumerate(add_fk):
                    if idx < len(add_fk) - 1:
                        new_body.append(fk + ',')
                    else:
                        new_body.append(fk)

            # table comment replace
            tcom = table_map.get(table, '数据表')
            if 'COMMENT=' in end:
                end = re.sub(r"COMMENT='[^']*'", f"COMMENT='{tcom}'", end)
            else:
                end = end.rstrip(';') + f" COMMENT='{tcom}';"

            block = [first] + new_body + [end]

        out_lines.extend(block)
    else:
        out_lines.append(line)
    i += 1

out.write_text('\n'.join(out_lines) + '\n', encoding='utf-8')
print(str(out))
