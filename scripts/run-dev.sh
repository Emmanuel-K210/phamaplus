#!/bin/bash
# Script de développement PharmaPlus

echo "🔧 MODE DÉVELOPPEMENT PHARMAPLUS"
echo "================================"

# Variables
TOMCAT_PORT=8080
POSTGRES_PORT=5432
PROJECT_DIR=$(pwd)

# Fonctions
check_port() {
    nc -z localhost $1 > /dev/null 2>&1
    return $?
}

start_services() {
    echo "1. Vérification des services..."

    # PostgreSQL
    if check_port $POSTGRES_PORT; then
        echo "✅ PostgreSQL est en cours d'exécution"
    else
        echo "⚠ PostgreSQL n'est pas démarré"
        echo "   Démarrez-le avec: sudo systemctl start postgresql"
    fi

    # Tomcat
    if check_port $TOMCAT_PORT; then
        echo "✅ Tomcat est en cours d'exécution"
    else
        echo "⚠ Tomcat n'est pas démarré"
        read -p "Voulez-vous démarrer Tomcat ? (o/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Oo]$ ]]; then
            sudo systemctl start tomcat9
            sleep 5
        fi
    fi
}

compile_project() {
    echo ""
    echo "2. Compilation du projet..."
    mvn clean compile
    if [ $? -eq 0 ]; then
        echo "✅ Compilation réussie"
    else
        echo "❌ Échec de la compilation"
        exit 1
    fi
}

hot_deploy() {
    echo ""
    echo "3. Déploiement à chaud..."

    # Compiler les classes
    mvn compile

    # Copier les classes compilées
    if [ -d "$TOMCAT_HOME/webapps/pharmaplus/WEB-INF/classes" ]; then
        cp -r target/classes/* "$TOMCAT_HOME/webapps/pharmaplus/WEB-INF/classes/"
        echo "✅ Classes Java mises à jour"
    fi

    # Copier les JSP
    if [ -d "$TOMCAT_HOME/webapps/pharmaplus" ]; then
        cp -r src/main/webapp/* "$TOMCAT_HOME/webapps/pharmaplus/"
        echo "✅ Fichiers JSP mis à jour"
    fi

    # Redémarrer le contexte
    curl -s "http://localhost:$TOMCAT_PORT/pharmaplus/" > /dev/null
    echo "✅ Contexte redémarré"
}

watch_changes() {
    echo ""
    echo "4. Surveillance des changements..."
    echo "   Appuyez sur Ctrl+C pour arrêter"
    echo ""

    # Utiliser fswatch ou inotifywait pour surveiller les changements
    if command -v fswatch &> /dev/null; then
        fswatch -r src/ | while read; do
            echo "📁 Changement détecté: $REPLY"
            hot_deploy
        done
    elif command -v inotifywait &> /dev/null; then
        inotifywait -m -r -e modify,create,delete src/ | while read; do
            echo "📁 Changement détecté"
            hot_deploy
        done
    else
        echo "⚠ Aucun outil de surveillance trouvé (fswatch ou inotifywait)"
        echo "   Installation recommandée:"
        echo "   - macOS: brew install fswatch"
        echo "   - Linux: sudo apt-get install inotify-tools"
    fi
}

main_menu() {
    while true; do
        echo ""
        echo "================================"
        echo "MENU DÉVELOPPEMENT PHARMAPLUS"
        echo "================================"
        echo "1. Compiler et déployer"
        echo "2. Surveillance continue"
        echo "3. Exécuter les tests"
        echo "4. Nettoyer le projet"
        echo "5. Ouvrir dans le navigateur"
        echo "6. Voir les logs Tomcat"
        echo "0. Quitter"
        echo ""
        read -p "Choix: " -n 1 -r
        echo

        case $REPLY in
            1)
                compile_project
                hot_deploy
                ;;
            2)
                watch_changes
                ;;
            3)
                mvn test
                ;;
            4)
                mvn clean
                echo "✅ Projet nettoyé"
                ;;
            5)
                xdg-open "http://localhost:$TOMCAT_PORT/pharmaplus" 2>/dev/null || \
                open "http://localhost:$TOMCAT_PORT/pharmaplus" 2>/dev/null || \
                echo "Ouvrez: http://localhost:$TOMCAT_PORT/pharmaplus"
                ;;
            6)
                tail -f "$TOMCAT_HOME/logs/catalina.out"
                ;;
            0)
                echo "Au revoir ! 👋"
                exit 0
                ;;
            *)
                echo "Choix invalide"
                ;;
        esac
    done
}

# Exécution
start_services
main_menu