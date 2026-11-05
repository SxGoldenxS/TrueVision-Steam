@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Update-Theme.ps1"
if errorlevel 1 echo Update did not complete. Read the message above. Discord support: daddysxgold
echo.
pause
