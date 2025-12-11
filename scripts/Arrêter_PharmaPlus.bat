@echo off
title PharmaPlus - Arrêt de l'Application
color 0C

echo ========================================
echo    ARRÊT DE PHARMAPLUS
echo ========================================
echo.

set TOMCAT_HOME=%~dp0Tomcat

:: Vérifier si Tomcat existe
if not exist "%TOMCAT_HOME%" (
    echo ❌ Dossier Tomcat non trouvé
    pause
    exit /b 1
)

echo 1. Arrêt du serveur...
call "%TOMCAT_HOME%\bin\shutdown.bat" >nul 2>&1

echo 2. Arrêt des processus restants...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8082') do (
    echo   Arrêt du processus PID %%i...
    taskkill /F /PID %%i >nul 2>&1
)

echo 3. Nettoyage des fichiers temporaires...
del /Q "%TOMCAT_HOME%\temp\*" >nul 2>&1
del /Q "%TOMCAT_HOME%\work\Catalina\localhost\phamaplus\*" >nul 2>&1

echo.
echo ✅ PHARMAPLUS ARRÊTÉ AVEC SUCCÈS
echo.
echo Pour relancer l'application :
echo • Double-cliquez sur 'Lancer_PharmaPlus.bat'
echo • OU sur le raccourci 'PharmaPlus' de votre bureau
echo.
pause