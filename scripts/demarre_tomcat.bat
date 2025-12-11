@echo off
title PharmaPlus - Demarrage Tomcat
echo ========================================
echo    PHARMAPLUS - DEMARRAGE TOMCAT
echo ========================================

rem Verification installation Tomcat
if not exist "C:\apache-tomcat-10.1.49" (
    echo ❌ Tomcat non trouve a: C:\apache-tomcat-10.1.49
    echo.
    echo Instructions:
    echo 1. Telechargez Tomcat 10.1.49: https://tomcat.apache.org/download-10.cgi
    echo 2. Extrayez dans C:\apache-tomcat-10.1.49
    pause
    exit /b 1
)

rem Definition des variables
set CATALINA_HOME=C:\apache-tomcat-10.1.49
set CATALINA_BASE=C:\apache-tomcat-10.1.49
set JAVA_HOME=C:\Program Files\Java\jdk-25

rem Verification Java
if not exist "%JAVA_HOME%" (
    echo ⚠️ JDK 25 non trouve, recherche d'une autre version...
    for /d %%i in ("C:\Program Files\Java\jdk*") do set JAVA_HOME=%%i
    if not exist "%JAVA_HOME%" (
        echo ❌ Java JDK non trouve
        echo Telechargez Java: https://adoptium.net/
        pause
        exit /b 1
    )
)

echo.
echo ✅ Configuration detectee:
echo Tomcat: %CATALINA_HOME%
echo Java: %JAVA_HOME%
echo.

rem Demarrage Tomcat
echo Demarrage de Tomcat...
echo.

cd /d "%CATALINA_HOME%\bin"
call startup.bat

rem Attendre pour voir les logs
timeout /t 5 /nobreak >nul

echo.
echo ✅ Tomcat demarre !
echo.
echo 📍 Acces a l'application:
echo URL: http://localhost:8080/phamaplus
echo.
echo 👤 Comptes par defaut:
echo - Administrateur: admin / admin123
echo - Pharmacien: pharma / pharma123
echo.
pause