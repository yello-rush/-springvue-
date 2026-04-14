#!/usr/bin/env python3
import os
import subprocess

# 未登录用户用例图
unlogged_uml = '''
@startuml
left to right direction

actor "未登录用户" as Actor1
actor "未登录（商家版）" as Actor2
actor "未登录（管理员版）" as Actor3

usecase "浏览首页" as UC1
usecase "查看文章列表" as UC2
usecase "查看文章详情" as UC3
usecase "查看分类" as UC4
usecase "查看标签" as UC5
usecase "查看说说" as UC6
usecase "查看评论" as UC7
usecase "搜索文章" as UC8
usecase "注册账号" as UC9
usecase "登录账号" as UC10
usecase "找回密码" as UC11

Actor1 --> UC1
Actor1 --> UC2
Actor1 --> UC3
Actor1 --> UC4
Actor1 --> UC5
Actor1 --> UC6
Actor1 --> UC7
Actor1 --> UC8
Actor1 --> UC9
Actor1 --> UC10
Actor1 --> UC11

Actor2 --> UC9
Actor2 --> UC10

Actor3 --> UC10

@enduml
'''

# 登录用户用例图
logged_uml = '''
@startuml
left to right direction

actor "登录用户" as Actor1

usecase "退出账号" as UC1
usecase "修改密码" as UC2
usecase "找回密码" as UC3
usecase "编辑个人信息" as UC4
usecase "显示个人信息" as UC5
usecase "发布文章" as UC6
usecase "编辑文章" as UC7
usecase "删除文章" as UC8
usecase "查看文章" as UC9
usecase "搜索文章" as UC10
usecase "发表评论" as UC11
usecase "回复评论" as UC12
usecase "删除评论" as UC13
usecase "点赞评论" as UC14
usecase "发布说说" as UC15
usecase "编辑说说" as UC16
usecase "删除说说" as UC17
usecase "点赞说说" as UC18
usecase "上传图片" as UC19
usecase "上传文件" as UC20

Actor1 --> UC1
Actor1 --> UC2
Actor1 --> UC3
Actor1 --> UC4
Actor1 --> UC5
Actor1 --> UC6
Actor1 --> UC7
Actor1 --> UC8
Actor1 --> UC9
Actor1 --> UC10
Actor1 --> UC11
Actor1 --> UC12
Actor1 --> UC13
Actor1 --> UC14
Actor1 --> UC15
Actor1 --> UC16
Actor1 --> UC17
Actor1 --> UC18
Actor1 --> UC19
Actor1 --> UC20

@enduml
'''

# 管理员用例图
admin_uml = '''
@startuml
left to right direction

actor "管理员" as Actor1

usecase "退出账号" as UC1
usecase "修改密码" as UC2
usecase "查看用户" as UC3
usecase "编辑用户" as UC4
usecase "禁用用户" as UC5
usecase "搜索用户" as UC6
usecase "审核文章" as UC7
usecase "查看文章" as UC8
usecase "搜索文章" as UC9
usecase "删除文章" as UC10
usecase "审核评论" as UC11
usecase "查看评论" as UC12
usecase "删除评论" as UC13
usecase "添加分类" as UC14
usecase "编辑分类" as UC15
usecase "删除分类" as UC16
usecase "添加标签" as UC17
usecase "管理标签" as UC18
usecase "查看资源" as UC19
usecase "管理资源" as UC20
usecase "网站设置" as UC21
usecase "导航菜单配置" as UC22
usecase "权限设置" as UC23
usecase "查看系统日志" as UC24
usecase "管理缓存" as UC25

Actor1 --> UC1
Actor1 --> UC2
Actor1 --> UC3
Actor1 --> UC4
Actor1 --> UC5
Actor1 --> UC6
Actor1 --> UC7
Actor1 --> UC8
Actor1 --> UC9
Actor1 --> UC10
Actor1 --> UC11
Actor1 --> UC12
Actor1 --> UC13
Actor1 --> UC14
Actor1 --> UC15
Actor1 --> UC16
Actor1 --> UC17
Actor1 --> UC18
Actor1 --> UC19
Actor1 --> UC20
Actor1 --> UC21
Actor1 --> UC22
Actor1 --> UC23
Actor1 --> UC24
Actor1 --> UC25

@enduml
'''

def generate_uml_image(uml_code, output_file):
    # 写入临时文件
    with open('temp.uml', 'w', encoding='utf-8') as f:
        f.write(uml_code)
    
    # 生成图片
    subprocess.run(['java', '-jar', 'plantuml.jar', 'temp.uml', '-tpng', '-o', '.'], 
                  capture_output=True, text=True)
    
    # 重命名输出文件
    os.rename('temp.png', output_file)
    
    # 清理临时文件
    os.remove('temp.uml')

if __name__ == '__main__':
    print("生成未登录用户用例图...")
    generate_uml_image(unlogged_uml, 'unlogged_user_usecase.png')
    
    print("生成登录用户用例图...")
    generate_uml_image(logged_uml, 'logged_user_usecase.png')
    
    print("生成管理员用例图...")
    generate_uml_image(admin_uml, 'admin_usecase.png')
    
    print("生成完成！")
