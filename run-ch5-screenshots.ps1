$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Write-Step($msg) {
  Write-Host "`n==> $msg" -ForegroundColor Cyan
}

function Test-PortOpen {
  param(
    [string]$HostName,
    [int]$Port
  )
  try {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect($HostName, $Port, $null, $null)
    $ok = $iar.AsyncWaitHandle.WaitOne(800, $false)
    if (-not $ok) {
      $client.Close()
      return $false
    }
    $client.EndConnect($iar)
    $client.Close()
    return $true
  } catch {
    return $false
  }
}

function Wait-PortReady {
  param(
    [string]$Name,
    [string]$HostName,
    [int]$Port,
    [int]$TimeoutSec = 180
  )
  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  while ((Get-Date) -lt $deadline) {
    if (Test-PortOpen -HostName $HostName -Port $Port) {
      Write-Host "[$Name] 端口 $Port 已就绪" -ForegroundColor Green
      return
    }
    Start-Sleep -Milliseconds 800
  }
  throw "[$Name] 端口 $Port 在 ${TimeoutSec}s 内未就绪"
}

function Start-BackgroundProcess {
  param(
    [string]$Name,
    [string]$WorkingDir,
    [string]$Command,
    [string]$LogPath
  )

  $escapedDir = $WorkingDir.Replace("'", "''")
  $escapedCommand = $Command.Replace("'", "''")
  $escapedLog = $LogPath.Replace("'", "''")

  $psCommand = @"
Set-Location -Path '$escapedDir'
Write-Host '[${Name}] working dir: $escapedDir'
$escapedCommand *>> '$escapedLog'
"@

  Write-Host "启动 [$Name]..." -ForegroundColor Yellow
  $proc = Start-Process -FilePath "powershell.exe" `
    -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $psCommand) `
    -PassThru `
    -WindowStyle Minimized
  return $proc
}

function Ensure-CommandExists {
  param([string]$Cmd)
  $exists = Get-Command $Cmd -ErrorAction SilentlyContinue
  if (-not $exists) {
    throw "未检测到命令: $Cmd，请先安装并加入 PATH。"
  }
}

$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$blogDir = Join-Path $rootDir "blog"
$webDir = Join-Path $rootDir "blog-web"
$adminDir = Join-Path $rootDir "blog-admin"
$logDir = Join-Path $rootDir "logs\ch5-screenshot"
$shotDir = Join-Path $rootDir "docs\images\ch5"
$envFile = Join-Path $rootDir "ch5-screenshot.env.ps1"

New-Item -ItemType Directory -Force -Path $logDir | Out-Null
New-Item -ItemType Directory -Force -Path $shotDir | Out-Null

Write-Step "环境检查"
Ensure-CommandExists -Cmd "node"
Ensure-CommandExists -Cmd "npm"
Ensure-CommandExists -Cmd "mvn"

if (Test-Path $envFile) {
  Write-Host "加载配置文件: $envFile"
  . $envFile
}

if (-not $env:ADMIN_USERNAME) { $env:ADMIN_USERNAME = Read-Host "请输入 ADMIN_USERNAME（后台账号）" }
if (-not $env:ADMIN_PASSWORD) { $env:ADMIN_PASSWORD = Read-Host "请输入 ADMIN_PASSWORD（后台密码）" }
if (-not $env:WEB_EMAIL) { $env:WEB_EMAIL = Read-Host "请输入 WEB_EMAIL（前台邮箱）" }
if (-not $env:WEB_PASSWORD) { $env:WEB_PASSWORD = Read-Host "请输入 WEB_PASSWORD（前台密码）" }
if (-not $env:WEB_SECURITY_CODE) { $env:WEB_SECURITY_CODE = Read-Host "请输入 WEB_SECURITY_CODE（4位安全码）" }

if (-not $env:ADMIN_BASE_URL) { $env:ADMIN_BASE_URL = "http://localhost:3000" }
if (-not $env:WEB_BASE_URL) { $env:WEB_BASE_URL = "http://localhost:3001" }
if (-not $env:FORGOT_WRONG_SECURITY_CODE) { $env:FORGOT_WRONG_SECURITY_CODE = "0000" }
if (-not $env:FORGOT_NEW_PASSWORD) { $env:FORGOT_NEW_PASSWORD = "Test@123456" }

$procs = @()

try {
  Write-Step "启动后端服务（8800）"
  $backendLog = Join-Path $logDir "backend.log"
  $backendCmd = "mvn -pl mojian-server -am spring-boot:run -Dspring-boot.run.profiles=dev"
  $backendProc = Start-BackgroundProcess -Name "backend" -WorkingDir $blogDir -Command $backendCmd -LogPath $backendLog
  $procs += $backendProc

  Write-Step "启动后台前端（3000）"
  $adminLog = Join-Path $logDir "admin.log"
  $adminProc = Start-BackgroundProcess -Name "admin-web" -WorkingDir $adminDir -Command "npm run dev" -LogPath $adminLog
  $procs += $adminProc

  Write-Step "启动用户前端（3001）"
  $webLog = Join-Path $logDir "web.log"
  $webProc = Start-BackgroundProcess -Name "blog-web" -WorkingDir $webDir -Command "npm run dev" -LogPath $webLog
  $procs += $webProc

  Write-Step "等待服务端口就绪"
  Wait-PortReady -Name "backend" -HostName "127.0.0.1" -Port 8800 -TimeoutSec 240
  Wait-PortReady -Name "admin-web" -HostName "127.0.0.1" -Port 3000 -TimeoutSec 180
  Wait-PortReady -Name "blog-web" -HostName "127.0.0.1" -Port 3001 -TimeoutSec 180

  Write-Step "执行第5章自动截图"
  Push-Location $webDir
  try {
    npm run test:ch5:screenshot
  } finally {
    Pop-Location
  }

  Write-Step "截图完成"
  Write-Host "输出目录: $shotDir" -ForegroundColor Green
} catch {
  Write-Host "`n执行失败: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host "请查看日志目录: $logDir" -ForegroundColor Yellow
  throw
} finally {
  Write-Step "停止后台进程"
  foreach ($p in $procs) {
    if ($null -ne $p -and -not $p.HasExited) {
      try {
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
      } catch {
      }
    }
  }
}
