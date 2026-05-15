# 复制本文件为 ch5-screenshot.env.ps1 并填写真实值

$env:ADMIN_BASE_URL = "http://localhost:3000"
$env:WEB_BASE_URL = "http://localhost:3001"

$env:ADMIN_USERNAME = "admin"
$env:ADMIN_PASSWORD = "123456"

$env:WEB_EMAIL = "1111@qq.com"
$env:WEB_PASSWORD = "123456"
$env:WEB_SECURITY_CODE = "1111"

# 错误安全码（用于 fig5-14）
$env:FORGOT_WRONG_SECURITY_CODE = "0000"

# 找回密码时设置的新密码（用于 fig5-15）
$env:FORGOT_NEW_PASSWORD = "12345678"
