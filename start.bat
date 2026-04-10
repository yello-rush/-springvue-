@echo off
:: 强制使用 UTF-8 编码，防止乱码
chcp 65001 >nul
title 拾壹博客 一键启动脚本

echo ==========================================
echo       毕业设计博客 一键启动脚本
echo ==========================================

echo [1/4] 检查环境配置...
java -version >nul 2>&1
if errorlevel 1 ( 
    echo [错误] 未检测到 Java，请安装 JDK 8+ 
    pause 
    exit /b 
)

call mvn -v >nul 2>&1
if errorlevel 1 ( 
    echo [错误] 未检测到 Maven，请配置 Maven 
    pause 
    exit /b 
)

call node -v >nul 2>&1
if errorlevel 1 ( 
    echo [错误] 未检测到 Node.js，请安装 Node.js 
    pause 
    exit /b 
)

echo [2/4] 启动后端服务 (Spring Boot - Port 8800)...
cd blog
if not exist "mojian-server\target\mojian-blog.jar" (
    echo 正在编译后端代码，请稍候...
    call mvn clean package -DskipTests
)
start "Blog Backend (Port 8800)" cmd /k "chcp 65001 >nul && java -jar mojian-server\target\mojian-blog.jar"
cd ..

echo [3/4] 启动后台管理端 (Vue Admin - Port 3000)...
cd blog-admin
if not exist "node_modules" (
    echo 安装管理端依赖...
    call npm install
)
start "Blog Admin (Port 3000)" cmd /k "chcp 65001 >nul && npm run dev"
cd ..

echo [4/4] 启动前台用户端 (Vue Web - Port 3001)...
cd blog-web
if not exist "node_modules" (
    echo 安装前台依赖...
    call npm install
)
start "Blog Web (Port 3001)" cmd /k "chcp 65001 >nul && npm run dev"
cd ..

echo ==========================================
echo 所有服务已启动！请检查弹出的三个命令窗口。
echo 前台门户 : http://localhost:3001
echo 后台管理: http://localhost:3000
echo 后端接口: http://localhost:8800
echo ==========================================
pause