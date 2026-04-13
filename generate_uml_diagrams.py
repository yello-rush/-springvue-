#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用在线PlantUML服务生成UML用例图
"""

import requests
import base64
import zlib

def plantuml_text_to_image(plantuml_text):
    """将PlantUML文本转换为图片URL"""
    # 压缩和编码PlantUML文本
    compressed = zlib.compress(plantuml_text.encode('utf-8'))[2:-4]
    encoded = base64.b64encode(compressed).decode('utf-8')
    
    # 使用PlantUML编码表
    trans = str.maketrans(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'
    )
    plantuml_code = encoded.translate(trans)
    
    # 生成图片URL
    image_url = f"http://www.plantuml.com/plantuml/png/{plantuml_code}"
    return image_url

# 读取PlantUML文件
with open('/workspace/unlogged_user_usecase.puml', 'r', encoding='utf-8') as f:
    unlogged_text = f.read()

with open('/workspace/logged_user_usecase.puml', 'r', encoding='utf-8') as f:
    logged_text = f.read()

with open('/workspace/admin_usecase.puml', 'r', encoding='utf-8') as f:
    admin_text = f.read()

# 生成图片URL
unlogged_url = plantuml_text_to_image(unlogged_text)
logged_url = plantuml_text_to_image(logged_text)
admin_url = plantuml_text_to_image(admin_text)

# 保存URL到文件
with open('/workspace/uml_diagrams_urls.txt', 'w', encoding='utf-8') as f:
    f.write("未登录用户用例图：\n")
    f.write(unlogged_url + "\n\n")
    f.write("登录用户用例图：\n")
    f.write(logged_url + "\n\n")
    f.write("管理员用例图：\n")
    f.write(admin_url + "\n\n")

print("未登录用户用例图URL：", unlogged_url)
print("登录用户用例图URL：", logged_url)
print("管理员用例图URL：", admin_url)
print("\nURL已保存到 /workspace/uml_diagrams_urls.txt")
