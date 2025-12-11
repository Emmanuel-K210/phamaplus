@echo off
title PharmaPlus - Système de Gestion Pharmaceutique
mode con: cols=80 lines=25
color 0A

echo ========================================
echo    PHARMAPLUS - LANCEMENT APPLICATION
echo ========================================
echo.
echo Ce programme va :
echo 1. Démarrer le serveur PharmaPlus
echo 2. Ouvrir votre navigateur automatiquement
echo 3. Lancer l'interface de gestion
echo.
echo ⚠️  IMPORTANT : Ne fermez pas cette fenêtre !
echo    Elle contient le serveur en arrière-plan.
echo.
pause
cls

:: ========================================
:: CONFIGURATION
:: ========================================
set TOMCAT_HOME=%~dp0Tomcat
set APP_URL=http://localhost:8082/phamaplus
set WAIT_TIME=15

echo ========================================
echo    ÉTAPE 1 : VÉRIFICATION
echo ========================================
echo.

:: Vérifier si Tomcat existe
if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo ❌ ERREUR : Tomcat non trouvé dans %TOMCAT_HOME%
    echo.
    echo Solutions :
    echo 1. Vérifiez que le dossier 'Tomcat' existe bien
    echo 2. Réinstallez PharmaPlus avec Setup_PharmaPlus.bat
    echo.
    pause
    exit /b 1
)

:: Vérifier si l'application est déployée
if not exist "%TOMCAT_HOME%\webapps\phamaplus.war" (
    if not exist "%TOMCAT_HOME%\webapps\phamaplus" (
        echo ⚠️  ATTENTION : Application non déployée
        echo Déploiement en cours...
        copy "%~dp0Application\phamaplus.war" "%TOMCAT_HOME%\webapps\" >nul
        echo ✅ Application déployée
    )
)

:: Vérifier si Java est installé
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERREUR : Java non installé
    echo.
    echo Téléchargez Java 11+ depuis :
    echo https://adoptium.net/temurin/releases/
    echo.
    pause
    exit /b 1
)

echo ✅ Toutes les vérifications OK
echo.

:: ========================================
:: ÉTAPE 2 : ARRÊTER LES INSTANCES EXISTANTES
:: ========================================
echo ========================================
echo    ÉTAPE 2 : PRÉPARATION
echo ========================================
echo.

echo Vérification des instances existantes...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8082') do (
    echo Arrêt du processus %%i sur le port 8082...
    taskkill /F /PID %%i >nul 2>&1
)

:: Arrêter Tomcat s'il tourne
if exist "%TOMCAT_HOME%\bin\shutdown.bat" (
    call "%TOMCAT_HOME%\bin\shutdown.bat" >nul 2>&1
    timeout /t 3 /nobreak >nul
)

echo ✅ Serveur préparé
echo.

:: ========================================
:: ÉTAPE 3 : DÉMARRER TOMCAT
:: ========================================
echo ========================================
echo    ÉTAPE 3 : DÉMARRAGE SERVEUR
echo ========================================
echo.

echo Démarrage de PharmaPlus...
echo Patientez %WAIT_TIME% secondes...

:: Définir les variables d'environnement
set CATALINA_HOME=%TOMCAT_HOME%
set CATALINA_BASE=%TOMCAT_HOME%
set JAVA_HOME=%ProgramFiles%\Java\jdk-11

:: Démarrer Tomcat en arrière-plan
start "PharmaPlus Server" /MIN cmd /c ""%TOMCAT_HOME%\bin\startup.bat""

:: Attendre le démarrage
echo.
echo [                    ] 0%%
timeout /t 2 /nobreak >nul
echo [####                ] 20%%
timeout /t 3 /nobreak >nul
echo [########            ] 40%%
timeout /t 3 /nobreak >nul
echo [############        ] 60%%
timeout /t 3 /nobreak >nul
echo [################    ] 80%%
timeout /t 4 /nobreak >nul
echo [####################] 100%%
echo.

:: ========================================
:: ÉTAPE 4 : VÉRIFICATION
:: ========================================
echo ========================================
echo    ÉTAPE 4 : VÉRIFICATION
echo ========================================
echo.

echo Test de la connexion...
curl -s -o nul -w "Code HTTP: %%{http_code}\n" "%APP_URL%" --connect-timeout 10
if %errorlevel% equ 0 (
    echo ✅ Serveur démarré avec succès !
) else (
    echo ⚠️  Le serveur démarre, veuillez patienter...
    echo L'application sera disponible dans quelques instants.
)

:: ========================================
:: ÉTAPE 5 : OUVRIR LE NAVIGATEUR
:: ========================================
echo ========================================
echo    ÉTAPE 5 : LANCEMENT INTERFACE
echo ========================================
echo.

echo Ouverture du navigateur...
start "" "%APP_URL%"

:: ========================================
:: ÉTAPE 6 : AFFICHER LES INFORMATIONS
:: ========================================
echo ========================================
echo    ✅ PHARMAPLUS EST PRÊT !
echo ========================================
echo.
echo 📍 ADRESSE DE L'APPLICATION :
echo    %APP_URL%
echo.
echo 👤 IDENTIFIANTS DE CONNEXION :
echo    • Administrateur : admin / admin123
echo    • Pharmacien     : pharma / pharma123
echo.
echo ⚠️  IMPORTANT :
echo    1. CHANGEZ ces mots de passe dès la première connexion !
echo    2. Ne fermez PAS cette fenêtre (serveur en cours d'exécution)
echo    3. Pour arrêter : double-cliquez sur 'Arrêter_PharmaPlus.bat'
echo.
echo 📞 SUPPORT : support@pharmaplus.com
echo ========================================
echo.

:: ========================================
:: MENU INTERACTIF
:: ========================================
:menu
echo.
echo Que souhaitez-vous faire ?
echo 1. Rafraîchir la page (réouvrir le navigateur)
echo 2. Afficher l'URL pour copier/coller
echo 3. Voir les logs du serveur
echo 4. Arrêter PharmaPlus et quitter
echo 5. Continuer (laisser tourner en arrière-plan)
echo.

choice /c 12345 /n /m "Votre choix [1-5] : "

if %errorlevel% equ 1 (
    echo Ouverture du navigateur...
    start "" "%APP_URL%"
    goto menu
)

if %errorlevel% equ 2 (
    echo.
    echo 📋 URL à copier :
    echo %APP_URL%
    echo.
    pause
    goto menu
)

if %errorlevel% equ 3 (
    echo.
    echo 📜 Derniers logs (Ctrl+C pour revenir au menu) :
    echo ========================================
    type "%TOMCAT_HOME%\logs\catalina.out" | more
    echo ========================================
    goto menu
)

if %errorlevel% equ 4 (
    echo.
    echo Arrêt de PharmaPlus...
    call "%~dp0Arrêter_PharmaPlus.bat"
    exit /b 0
)

if %errorlevel% equ 5 (
    echo.
    echo ✅ PharmaPlus tourne en arrière-plan.
    echo Fenêtre réduite dans la barre des tâches.
    echo Pour arrêter : 'Arrêter_PharmaPlus.bat'
    echo.
    echo Appuyez sur une touche pour minimiser...
    pause >nul
    exit /b 0
)

goto menu