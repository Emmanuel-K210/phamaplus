@echo off
chcp 65001 >nul
title PharmaPlus - Lancement
color 0A
echo PharmaPlus - Lancement...
echo.

set "CATALINA_HOME=%~dp0Tomcat"
set "CATALINA_BASE=%~dp0Tomcat"
set "APP_URL=http://localhost:8082/phamaplus"

echo Arrêt instances existantes...
call :kill8082

echo.
echo Démarrage Tomcat...
start "Tomcat" /MIN "%CATALINA_HOME%\bin\startup.bat"

echo Attente 10 secondes...
timeout /t 10 /nobreak >nul

echo.
echo Ouverture navigateur...
start "" "%APP_URL%"

echo.
echo ✅ PharmaPlus démarré !
echo URL : %APP_URL%
echo Admin : admin / admin123
echo.
echo ⚠️  Ne fermez pas cette fenêtre !
echo Pour arrêter : Arrêter_PharmaPlus.bat
echo.
pause
exit /b

:kill8082
for /f "tokens=5" %%i in ('netstat -ano 2^>nul ^| findstr ":8082"') do (
    taskkill /F /PID %%i >nul 2>&1
)
exit /b