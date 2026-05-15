@echo off
setlocal
set SCRIPT_DIR=%~dp0
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%run-ch5-screenshots.ps1"
if %errorlevel% neq 0 (
  echo.
  echo Script failed with exit code %errorlevel%.
  pause
  exit /b %errorlevel%
)
echo.
echo Done.
pause
