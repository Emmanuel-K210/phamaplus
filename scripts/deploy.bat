@echo off
chcp 65001 >nul
title PharmaPlus - Création Package Simple
echo ========================================
echo    CRÉATION PACKAGE CLIENT (Version Simple)
echo ========================================
echo.

:: Configuration simple
set TOMCAT_SOURCE=C:\apache-tomcat-10.1.49
set WAR_SOURCE=C:\Users\yaobi\IdeaProjects\phamaplus\target\phamaplus.war
set OUTPUT=C:\PharmaPlus_Client

echo Vérifications...
if not exist "%TOMCAT_SOURCE%" (
    echo ❌ Tomcat non trouvé : %TOMCAT_SOURCE%
    pause
    exit /b 1
)

if not exist "%WAR_SOURCE%" (
    echo ❌ WAR non trouvé : %WAR_SOURCE%
    echo Générez le WAR d'abord : mvn clean package
    pause
    exit /b 1
)

echo ✅ Tous les fichiers trouvés
echo.

:: Créer dossier de sortie
echo Création dossier client...
if exist "%OUTPUT%" rmdir /S /Q "%OUTPUT%" 2>nul
mkdir "%OUTPUT%" 2>nul
mkdir "%OUTPUT%\Tomcat" 2>nul

:: Copier Tomcat
echo Copie Tomcat...
xcopy "%TOMCAT_SOURCE%\*" "%OUTPUT%\Tomcat\" /E /I /H /Y

:: Configurer port 8082
echo Configuration port 8082...
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<Server port="8005" shutdown="SHUTDOWN"^>
echo   ^<Service name="Catalina"^>
echo     ^<Connector port="8082" protocol="HTTP/1.1"
echo                connectionTimeout="20000"
echo                redirectPort="8443" /^>
echo     ^<Engine name="Catalina" defaultHost="localhost"^>
echo       ^<Host name="localhost" appBase="webapps"
echo              unpackWARs="true" autoDeploy="true"^>
echo       ^</Host^>
echo     ^</Engine^>
echo   ^</Service^>
echo ^</Server^>
) > "%OUTPUT%\Tomcat\conf\server.xml"

:: Copier le WAR
echo Déploiement application...
copy "%WAR_SOURCE%" "%OUTPUT%\Tomcat\webapps\phamaplus.war" /Y

:: Créer les scripts - VERSION CORRIGÉE
echo Création scripts...

:: Lancer_PharmaPlus.bat - CORRIGÉ
(
echo @echo off
echo chcp 65001 ^>nul
echo echo PharmaPlus - Lancement...
echo echo.
echo set "CATALINA_HOME=%%~dp0Tomcat"
echo set "CATALINA_BASE=%%~dp0Tomcat"
echo.
echo echo Arrêt instances existantes...
echo call :kill8082
echo.
echo echo Démarrage Tomcat...
echo start "Tomcat" /MIN "%%CATALINA_HOME%%\bin\startup.bat"
echo.
echo echo Attente 10 secondes...
echo timeout /t 10 /nobreak ^>nul
echo.
echo echo Ouverture navigateur...
echo start http://localhost:8082/phamaplus
echo.
echo echo.
echo echo ✅ PharmaPlus démarré !
echo echo URL : http://localhost:8082/phamaplus
echo echo Admin : admin / admin123
echo echo.
echo pause
echo exit /b
echo.
echo :kill8082
echo for /f "tokens=5" %%%%i in ('netstat -ano ^| findstr ":8082 "'^) do ^(
echo    taskkill /F /PID %%%%i ^>nul 2^>^&1
echo ^)
echo exit /b
) > "%OUTPUT%\Lancer_PharmaPlus.bat"

:: Arrêter_PharmaPlus.bat - CORRIGÉ
(
echo @echo off
echo chcp 65001 ^>nul
echo echo PharmaPlus - Arrêt...
echo set "CATALINA_HOME=%%~dp0Tomcat"
echo call "%%CATALINA_HOME%%\bin\shutdown.bat" ^>nul 2^>^&1
echo call :kill8082
echo echo ✅ PharmaPlus arrêté
echo pause
echo exit /b
echo.
echo :kill8082
echo for /f "tokens=5" %%%%i in ('netstat -ano ^| findstr ":8082 "'^) do ^(
echo    taskkill /F /PID %%%%i ^>nul 2^>^&1
echo ^)
echo exit /b
) > "%OUTPUT%\Arrêter_PharmaPlus.bat"

:: Documentation
(
echo PHARMAPLUS - MODE D'EMPLOI
echo ========================
echo.
echo 1. Extrayez ce dossier
echo 2. Double-cliquez sur Lancer_PharmaPlus.bat
echo 3. Utilisez http://localhost:8082/phamaplus
echo.
echo Identifiants : admin / admin123
echo.
echo Pour arrêter : Arrêter_PharmaPlus.bat
) > "%OUTPUT%\LISEZ_MOI.txt"

:: Créer ZIP - Détection automatique du Bureau
echo Création archive...

:: Essayer d'abord le Bureau français
set "DESKTOP=%USERPROFILE%\Bureau"
if not exist "%DESKTOP%" (
    :: Essayer le Bureau anglais
    set "DESKTOP=%USERPROFILE%\Desktop"
)
if not exist "%DESKTOP%" (
    :: Utiliser le dossier utilisateur comme fallback
    set "DESKTOP=%USERPROFILE%"
)

set "ZIP_PATH=%DESKTOP%\PharmaPlus_Client.zip"

echo Destination : %ZIP_PATH%
if exist "%ZIP_PATH%" del "%ZIP_PATH%"
powershell -Command "Compress-Archive -Path '%OUTPUT%\*' -DestinationPath '%ZIP_PATH%' -Force"

if exist "%ZIP_PATH%" (
    echo.
    echo ✅ PACKAGE CRÉÉ !
    echo Emplacement : %ZIP_PATH%
    echo.
    echo Testez en extrayant et lançant Lancer_PharmaPlus.bat
) else (
    echo.
    echo ❌ Erreur lors de la création du ZIP
    echo Le package est disponible dans : %OUTPUT%
    echo.
)
pause