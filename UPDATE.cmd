@echo off
setlocal
if not exist "%~dp0Update-Theme.ps1" goto missing
if not exist "%~dp0Install-Theme.ps1" goto missing
rem Windows cannot rename a folder used as a process's working directory.
cd /d "%TEMP%" || exit /b 1
rem Parse the whole block before the update replaces this batch file.
(
 powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Update-Theme.ps1"
 if errorlevel 1 (
  echo Update did not complete. Read the message above. Discord support: daddysxgold
  echo.
  pause
  exit /b 1
 ) else (
  echo.
  pause
  exit /b 0
 )
)
:missing
echo Updater files are missing. Extract the complete TrueVision ZIP and run INSTALL.cmd once.
echo Keep UPDATE.cmd, Update-Theme.ps1 and Install-Theme.ps1 together.
echo Discord support: daddysxgold
pause
exit /b 1
