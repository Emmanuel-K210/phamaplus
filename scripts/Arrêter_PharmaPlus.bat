@echo off
chcp 65001 >nul
echo PharmaPlus - Arrêt...
set "CATALINA_HOME=%~dp0Tomcat"
call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
call :kill8082
echo ✅ PharmaPlus arrêté
pause
exit /b

:kill8082
for /f "tokens=5" %%i in ('netstat -ano | findstr ":8082 "') do (
   taskkill /F /PID %%i >nul 2>&1
)
exit /b
