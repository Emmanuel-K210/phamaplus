@echo off
chcp 65001 >nul
title PharmaPlus - Création Package Client
echo ========================================
echo    CRÉATION PACKAGE CLIENT
echo ========================================
echo.

:: Configuration
set "TOMCAT_SOURCE=C:\apache-tomcat-10.1.49"
set "WAR_SOURCE=C:\Users\yaobi\IdeaProjects\phamaplus\target\phamaplus.war"
set "OUTPUT=C:\PharmaPlus_Client"

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
xcopy "%TOMCAT_SOURCE%\*" "%OUTPUT%\Tomcat\" /E /I /H /Y >nul

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
copy "%WAR_SOURCE%" "%OUTPUT%\Tomcat\webapps\phamaplus.war" /Y >nul

:: Créer les scripts
echo Création scripts...

:: Lancer_PharmaPlus.bat
(
echo @echo off
echo chcp 65001 ^>nul
echo title PharmaPlus - Lancement
echo color 0A
echo echo PharmaPlus - Lancement...
echo echo.
echo.
echo set "CATALINA_HOME=%%~dp0Tomcat"
echo set "CATALINA_BASE=%%~dp0Tomcat"
echo set "APP_URL=http://localhost:8082/phamaplus"
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
echo start "" "%%APP_URL%%"
echo.
echo echo.
echo echo ✅ PharmaPlus démarré !
echo echo URL : %%APP_URL%%
echo echo Admin : admin / admin123
echo echo.
echo echo ⚠️  Ne fermez pas cette fenêtre !
echo echo Pour arrêter : Arrêter_PharmaPlus.bat
echo echo.
echo pause
echo exit /b
echo.
echo :kill8082
echo for /f "tokens=5" %%%%i in ^('netstat -ano 2^^^>nul ^^^| findstr ":8082"'^) do ^(
echo     taskkill /F /PID %%%%i ^>nul 2^>^^^&1
echo ^)
echo exit /b
) > "%OUTPUT%\Lancer_PharmaPlus.bat"

:: Arrêter_PharmaPlus.bat
(
echo @echo off
echo chcp 65001 ^>nul
echo title PharmaPlus - Arrêt
echo color 0C
echo echo PharmaPlus - Arrêt...
echo echo.
echo set "CATALINA_HOME=%%~dp0Tomcat"
echo.
echo echo Arrêt du serveur Tomcat...
echo call "%%CATALINA_HOME%%\bin\shutdown.bat" ^>nul 2^>^^^&1
echo timeout /t 3 /nobreak ^>nul
echo.
echo echo Arrêt des processus sur le port 8082...
echo call :kill8082
echo.
echo echo ✅ PharmaPlus arrêté
echo timeout /t 2 /nobreak ^>nul
echo exit /b
echo.
echo :kill8082
echo for /f "tokens=5" %%%%i in ^('netstat -ano 2^^^>nul ^^^| findstr ":8082"'^) do ^(
echo     taskkill /F /PID %%%%i ^>nul 2^>^^^&1
echo ^)
echo exit /b
) > "%OUTPUT%\Arrêter_PharmaPlus.bat"

:: Documentation
(
echo ========================================
echo    PHARMAPLUS - MODE D'EMPLOI
echo ========================================
echo.
echo INSTALLATION :
echo 1. Extrayez ce dossier sur votre ordinateur
echo 2. Conservez tous les fichiers ensemble
echo.
echo DÉMARRAGE :
echo 1. Double-cliquez sur "Lancer_PharmaPlus.bat"
echo 2. Attendez l'ouverture automatique du navigateur
echo 3. Utilisez l'adresse : http://localhost:8082/phamaplus
echo.
echo IDENTIFIANTS PAR DÉFAUT :
echo • Administrateur : admin / admin123
echo • Pharmacien     : pharma / pharma123
echo.
echo ⚠️  IMPORTANT :
echo • Changez ces mots de passe dès la première connexion
echo • Ne fermez pas la fenêtre noire pendant l'utilisation
echo.
echo ARRÊT :
echo • Double-cliquez sur "Arrêter_PharmaPlus.bat"
echo • Attendez la confirmation d'arrêt
echo.
echo SUPPORT :
echo • Email : support@pharmaplus.com
echo • Documentation : Voir le manuel utilisateur
echo.
echo ========================================
) > "%OUTPUT%\LISEZ_MOI.txt"

:: Créer ZIP avec détection automatique
echo Création archive...
echo.

:: Détecter le Bureau
set "DESKTOP="
if exist "%USERPROFILE%\Bureau\" set "DESKTOP=%USERPROFILE%\Bureau"
if exist "%USERPROFILE%\Desktop\" set "DESKTOP=%USERPROFILE%\Desktop"
if "%DESKTOP%"=="" set "DESKTOP=%USERPROFILE%"

set "ZIP_PATH=%DESKTOP%\PharmaPlus_Client.zip"

echo Destination : %ZIP_PATH%
if exist "%ZIP_PATH%" del "%ZIP_PATH%" 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Compress-Archive -Path '%OUTPUT%\*' -DestinationPath '%ZIP_PATH%' -Force; exit 0 } catch { Write-Host 'Erreur PowerShell:' $_.Exception.Message; exit 1 }"

if %errorlevel% equ 0 (
    if exist "%ZIP_PATH%" (
        echo.
        echo ========================================
        echo    ✅ PACKAGE CRÉÉ AVEC SUCCÈS !
        echo ========================================
        echo.
        echo 📦 Fichier ZIP : %ZIP_PATH%
        echo 📁 Dossier source : %OUTPUT%
        echo.
        echo 📋 CONTENU DU PACKAGE :
        echo   • Lancer_PharmaPlus.bat
        echo   • Arrêter_PharmaPlus.bat
        echo   • LISEZ_MOI.txt
        echo   • Tomcat/ (serveur complet^)
        echo.
        echo 🎯 PROCHAINES ÉTAPES :
        echo   1. Testez le package localement
        echo   2. Partagez le ZIP à vos clients
        echo   3. Fournissez le manuel utilisateur
        echo.
    ) else (
        echo ❌ Le ZIP n'a pas été créé
        echo Le dossier est disponible dans : %OUTPUT%
    )
) else (
    echo.
    echo ❌ Erreur lors de la création du ZIP
    echo.
    echo 💡 Solutions :
    echo   1. Le package est disponible dans : %OUTPUT%
    echo   2. Créez le ZIP manuellement avec WinRAR/7-Zip
    echo   3. Ou utilisez : Compress-Archive dans PowerShell
    echo.
)

echo.
pause