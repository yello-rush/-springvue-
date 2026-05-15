@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
:: 强制使用 UTF-8 编码，防止乱码
chcp 65001 >nul
title 拾壹博客 一键启动脚本

set "FORCE_BUILD=0"
for %%A in (%*) do (
    if /I "%%~A"=="--build" set "FORCE_BUILD=1"
    if /I "%%~A"=="/build" set "FORCE_BUILD=1"
)

echo ==========================================
echo       毕业设计博客 一键启动脚本
echo ==========================================
if "%FORCE_BUILD%"=="1" (
    echo 启动模式: 强制重建后端 ^(--build^)
) else (
    echo 启动模式: 快速启动（仅在缺少JAR时构建后端）
)

echo [1/4] 检查环境配置...
java -version >nul 2>&1
if errorlevel 1 ( 
    echo [错误] 未检测到 Java，请安装 JDK 8+ 
    pause 
    exit /b 
)

call node -v >nul 2>&1
if errorlevel 1 ( 
    echo [错误] 未检测到 Node.js，请安装 Node.js 
    pause 
    exit /b 
)

echo [2/5] 清理端口占用...
call :kill_port 8800
call :kill_port 3000
call :kill_port 3001
call :kill_process_by_cmdline "mojian-server\target\mojian-blog.jar" "后端 Java 进程"

echo [3/5] 启动后端服务 (Spring Boot - Port 8800)...
cd blog
set "BACKEND_JAR=%~dp0blog\mojian-server\target\mojian-blog.jar"
set "NEED_BUILD=0"
if "%FORCE_BUILD%"=="1" set "NEED_BUILD=1"
if not exist "%BACKEND_JAR%" set "NEED_BUILD=1"
if "%NEED_BUILD%"=="0" (
    call :check_boot_jar "%BACKEND_JAR%"
    if errorlevel 1 (
        echo 检测到现有后端 JAR 不是可执行 Spring Boot 包，将自动重新构建。
        set "NEED_BUILD=1"
    )
)
if "%NEED_BUILD%"=="0" (
    for /f %%R in ('powershell -NoProfile -Command "$jar='%BACKEND_JAR%'; $jarTime=(Get-Item $jar).LastWriteTimeUtc; $latest=(Get-ChildItem '%~dp0blog' -Recurse -File -Include *.java,*.xml,*.yml,*.yaml,*.properties,pom.xml | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1).LastWriteTimeUtc; if($latest -gt $jarTime){'1'}else{'0'}"') do (
        set "SOURCE_NEWER=%%R"
    )
    if "!SOURCE_NEWER!"=="1" (
        echo 检测到后端源码有更新，将自动重新构建。
        set "NEED_BUILD=1"
    )
)

if "%NEED_BUILD%"=="1" (
    call mvn -v >nul 2>&1
    if errorlevel 1 (
        echo [错误] 需要构建后端，但未检测到 Maven，请配置 Maven
        pause
        exit /b 1
    )
    echo 正在构建后端可执行包，请稍候...
    call mvn -pl mojian-server -am package -DskipTests
    if errorlevel 1 (
        echo [错误] 后端构建失败，已停止启动流程
        pause
        exit /b 1
    )
) else (
    echo 检测到后端启动包已存在，跳过构建。
)
if not exist "%BACKEND_JAR%" (
    echo [错误] 未找到后端启动包: blog\mojian-server\target\mojian-blog.jar
    pause
    exit /b 1
)
call :check_boot_jar "%BACKEND_JAR%"
if errorlevel 1 (
    echo [错误] 后端 JAR 不是可执行 Spring Boot 包：%BACKEND_JAR%
    echo [建议] 请先关闭占用该 JAR 的进程，然后运行 start.bat --build
    pause
    exit /b 1
)
start "Blog Backend (Port 8800)" cmd /k "chcp 65001 >nul && java -jar ""%BACKEND_JAR%"""
cd ..

echo [4/5] 启动后台管理端 (Vue Admin - Port 3000)...
cd blog-admin
if not exist "node_modules" (
    echo 安装管理端依赖...
    call npm install
)
start "Blog Admin (Port 3000)" cmd /k "chcp 65001 >nul && npm run dev"
cd ..

echo [5/5] 启动前台用户端 (Vue Web - Port 3001)...
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
echo 说明: 需要强制重建后端时，可使用 start.bat --build
echo ==========================================
pause
exit /b

:check_boot_jar
set "CHECK_JAR=%~1"
if not exist "%CHECK_JAR%" exit /b 1
jar tf "%CHECK_JAR%" 2>nul | findstr /C:"org/springframework/boot/loader/JarLauncher.class" >nul
if errorlevel 1 exit /b 1
exit /b 0

:kill_port
set "PORT=%~1"
set "FOUND=0"
for /f %%p in ('powershell -NoProfile -Command "$ids=(Get-NetTCPConnection -LocalPort %PORT% -ErrorAction SilentlyContinue ^| Select-Object -ExpandProperty OwningProcess -Unique); if($ids){$ids}"') do (
    set "FOUND=1"
    echo 正在释放端口 %PORT%，结束进程 PID=%%p ...
    taskkill /F /T /PID %%p >nul 2>&1
    if errorlevel 1 (
        echo [警告] 结束 PID=%%p 失败，可能需要管理员权限运行脚本
    ) else (
        echo 已结束 PID=%%p
    )
)
if "!FOUND!"=="0" (
    echo 端口 %PORT% 未被占用或未检测到占用进程
) else (
    echo 端口 %PORT% 已清理
)
exit /b

:kill_process_by_cmdline
set "KEYWORD=%~1"
set "DESC=%~2"
set "FOUND=0"
for /f %%p in ('powershell -NoProfile -Command "$root=[System.IO.Path]::GetFullPath('%~dp0').TrimEnd('\').ToLower(); $keyword='%KEYWORD%'.ToLower(); $procs=Get-CimInstance Win32_Process -ErrorAction SilentlyContinue; foreach($proc in $procs){ $cmd=$proc.CommandLine; if(-not $cmd){ continue }; $name=$proc.Name; if($name -ne 'java.exe' -and $name -ne 'javaw.exe'){ continue }; $cmdLower=$cmd.ToLower(); if($cmdLower.Contains($root) -and $cmdLower.Contains($keyword)){ $proc.ProcessId } }" 2^>nul') do (
    echo %%p|findstr /r "^[0-9][0-9]*$" >nul
    if errorlevel 1 (
        echo [警告] 忽略异常PID标记: %%p
    ) else (
        set "FOUND=1"
        echo 发现残留%DESC%，结束进程 PID=%%p ...
        taskkill /F /T /PID %%p >nul 2>&1
        if errorlevel 1 (
            echo [警告] 结束 PID=%%p 失败，可能需要管理员权限运行脚本
        ) else (
            echo 已结束 PID=%%p
        )
    )
)
if "!FOUND!"=="1" (
    echo %DESC% 清理完成
)
exit /b
