@echo off
chcp 65001 >nul
title PharmaPlus - Arrêt de l'Application
color 0C

echo ========================================
echo    ARRÊT DE PHARMAPLUS
echo ========================================
echo.

set "TOMCAT_HOME=%~dp0Tomcat"

:: Vérifier si Tomcat existe
if not exist "%TOMCAT_HOME%" (
    echo ❌ Dossier Tomcat non trouvé
    pause
    exit /b 1
)

echo 1. Arrêt du serveur Tomcat...
if exist "%TOMCAT_HOME%\bin\shutdown.bat" (
    call "%TOMCAT_HOME%\bin\shutdown.bat" >nul 2>&1
    timeout /t 3 /nobreak >nul
    echo    ✅ Commande d'arrêt envoyée
) else (
    echo    ⚠️  Script shutdown.bat introuvable
)

echo.
echo 2. Arrêt des processus restants sur le port 8082...
call :kill_port_8082

echo.
echo 3. Nettoyage des fichiers temporaires...
if exist "%TOMCAT_HOME%\temp\" (
    del /Q "%TOMCAT_HOME%\temp\*" >nul 2>&1
    echo    ✅ Fichiers temporaires supprimés
)

if exist "%TOMCAT_HOME%\work\Catalina\localhost\phamaplus\" (
    rd /S /Q "%TOMCAT_HOME%\work\Catalina\localhost\phamaplus\" >nul 2>&1
    echo    ✅ Cache de l'application nettoyé
)

echo.
echo ========================================
echo    ✅ PHARMAPLUS ARRÊTÉ AVEC SUCCÈS
echo ========================================
echo.
echo Pour relancer l'application :
echo • Double-cliquez sur 'Lancer_PharmaPlus.bat'
echo • OU sur le raccourci 'PharmaPlus' de votre bureau
echo.
pause
exit /b 0

:: ========================================
:: FONCTION : KILL PORT 8082
:: ========================================
:kill_port_8082
set "FOUND=0"
for /f "tokens=5" %%i in ('netstat -ano ^| findstr ":8082"') do (
    set "FOUND=1"
    echo    Arrêt du processus PID %%i...
    taskkill /F /PID %%i >nul 2>&1
)
if "%FOUND%"=="0" (
    echo    ℹ️  Aucun processus trouvé sur le port 8082
) else (
    echo    ✅ Processus arrêtés
)
exit /b