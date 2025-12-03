#!/bin/bash
# =====================================================
# Script de déploiement PharmaPlus
# =====================================================

set -e  # Arrêter en cas d'erreur

echo "🚀 DÉPLOIEMENT PHARMAPLUS"
echo "========================================="

# Couleurs pour les messages
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonctions utilitaires
log_success() { echo -e "${GREEN}✓ $1${NC}"; }
log_error() { echo -e "${RED}✗ $1${NC}"; exit 1; }
log_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
log_info() { echo -e "➔ $1"; }

# =====================================================
# 1. VÉRIFICATION DES PRÉREQUIS
# =====================================================
log_info "1. Vérification des prérequis..."

# Vérifier Java
if ! command -v java &> /dev/null; then
    log_error "Java n'est pas installé. Installez Java 11+"
fi
java_version=$(java -version 2>&1 | head -n 1 | cut -d '"' -f2)
log_success "Java version: $java_version"

# Vérifier Maven
if ! command -v mvn &> /dev/null; then
    log_error "Maven n'est pas installé"
fi
log_success "Maven disponible"

# Vérifier PostgreSQL
if ! command -v psql &> /dev/null; then
    log_warning "PostgreSQL n'est pas installé ou psql non disponible"
else
    log_success "PostgreSQL disponible"
fi

# Vérifier Tomcat
TOMCAT_HOME="/opt/tomcat"
if [ ! -d "$TOMCAT_HOME" ]; then
    TOMCAT_HOME="/usr/local/tomcat"
fi
if [ ! -d "$TOMCAT_HOME" ]; then
    log_warning "Tomcat non trouvé dans /opt/tomcat ou /usr/local/tomcat"
else
    log_success "Tomcat trouvé: $TOMCAT_HOME"
fi

# =====================================================
# 2. CRÉATION DE LA BASE DE DONNÉES
# =====================================================
log_info "2. Configuration de la base de données..."

read -p "Nom d'utilisateur PostgreSQL [postgres]: " DB_USER
DB_USER=${DB_USER:-postgres}

read -sp "Mot de passe PostgreSQL: " DB_PASS
echo

# Tester la connexion
if PGPASSWORD=$DB_PASS psql -U "$DB_USER" -h localhost -c "\q" 2>/dev/null; then
    log_success "Connexion PostgreSQL réussie"

    # Exécuter le script SQL
    log_info "Création de la base de données..."
    if PGPASSWORD=$DB_PASS psql -U "$DB_USER" -h localhost -f database/setup.sql; then
        log_success "Base de données créée avec succès"
    else
        log_error "Échec de la création de la base de données"
    fi
else
    log_warning "Impossible de se connecter à PostgreSQL"
    log_info "Veuillez créer manuellement la base:"
    log_info "  psql -U postgres -f database/setup.sql"
fi

# =====================================================
# 3. CONFIGURATION DE L'APPLICATION
# =====================================================
log_info "3. Configuration de l'application..."

# Demander les credentials pour DatabaseConnection.java
read -p "Hôte PostgreSQL [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Port PostgreSQL [5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}

# Mettre à jour DatabaseConnection.java
CONFIG_FILE="src/main/java/com/pharmaplus/config/DatabaseConnection.java"
if [ -f "$CONFIG_FILE" ]; then
    sed -i.bak "s|jdbc:postgresql://localhost:5432/pharmaplus|jdbc:postgresql://$DB_HOST:$DB_PORT/pharmaplus|" "$CONFIG_FILE"
    sed -i "s|postgres|$DB_USER|" "$CONFIG_FILE"
    # Note: On ne stocke pas le mot de passe dans le script pour des raisons de sécurité
    log_success "Configuration DB mise à jour"
    log_warning "⚠ N'oubliez pas de mettre à jour le mot de passe dans DatabaseConnection.java"
else
    log_warning "Fichier DatabaseConnection.java non trouvé"
fi

# =====================================================
# 4. COMPILATION DU PROJET
# =====================================================
log_info "4. Compilation du projet..."

if mvn clean compile; then
    log_success "Compilation réussie"
else
    log_error "Échec de la compilation"
fi

# =====================================================
# 5. CRÉATION DU FICHIER WAR
# =====================================================
log_info "5. Création du package WAR..."

if mvn clean package -DskipTests; then
    log_success "Package WAR créé: target/pharmaplus.war"
    WAR_SIZE=$(du -h target/pharmaplus.war | cut -f1)
    log_info "Taille du WAR: $WAR_SIZE"
else
    log_error "Échec de la création du package"
fi

# =====================================================
# 6. DÉPLOIEMENT SUR TOMCAT
# =====================================================
log_info "6. Déploiement sur Tomcat..."

# Vérifier si Tomcat est en cours d'exécution
if systemctl is-active --quiet tomcat9 2>/dev/null || systemctl is-active --quiet tomcat 2>/dev/null; then
    log_info "Arrêt de Tomcat..."
    sudo systemctl stop tomcat9 2>/dev/null || sudo systemctl stop tomcat 2>/dev/null
    sleep 3
fi

# Copier le WAR
if [ -d "$TOMCAT_HOME/webapps" ]; then
    log_info "Copie du WAR vers $TOMCAT_HOME/webapps/"
    sudo cp target/pharmaplus.war "$TOMCAT_HOME/webapps/"
    log_success "Déploiement effectué"
else
    log_warning "Répertoire webapps de Tomcat non trouvé"
    log_info "Copiez manuellement: sudo cp target/pharmaplus.war $TOMCAT_HOME/webapps/"
fi

# Démarrer Tomcat
log_info "Démarrage de Tomcat..."
sudo systemctl start tomcat9 2>/dev/null || sudo systemctl start tomcat 2>/dev/null || log_warning "Impossible de démarrer Tomcat via systemctl"

# Attendre le démarrage
log_info "Attente du démarrage de l'application..."
sleep 10

# =====================================================
# 7. VÉRIFICATION
# =====================================================
log_info "7. Vérification du déploiement..."

# Vérifier si l'application répond
if curl -s http://localhost:8080/pharmaplus/ > /dev/null; then
    log_success "✅ Application déployée avec succès!"
    echo ""
    echo "========================================="
    echo "🌐 ACCÈS À L'APPLICATION"
    echo "========================================="
    echo "URL: http://localhost:8080/pharmaplus"
    echo ""
    echo "👤 UTILISATEURS PAR DÉFAUT"
    echo "-----------------------------------------"
    echo "Admin:      admin / admin"
    echo "Pharmacien: pharmacien / admin"
    echo "Assistant:  assistant / admin"
    echo "Caissier:   caissier / admin"
    echo ""
    echo "📁 RESSOURCES"
    echo "-----------------------------------------"
    echo "Base de données: pharmaplus"
    echo "Fichier WAR: target/pharmaplus.war"
    echo "Logs Tomcat: $TOMCAT_HOME/logs"
    echo "========================================="
else
    log_warning "L'application ne répond pas immédiatement"
    log_info "Vérifiez les logs: tail -f $TOMCAT_HOME/logs/catalina.out"
fi

# =====================================================
# 8. NETTOYAGE
# =====================================================
log_info "8. Nettoyage..."

# Sauvegarder la configuration
BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp "$CONFIG_FILE" "$BACKUP_DIR/" 2>/dev/null || true
cp "pom.xml" "$BACKUP_DIR/" 2>/dev/null || true
log_success "Configuration sauvegardée dans $BACKUP_DIR"

echo ""
log_success "✅ DÉPLOIEMENT TERMINÉ!"
echo ""
echo "Pour vérifier le statut:"
echo "  sudo systemctl status tomcat9"
echo "Pour voir les logs:"
echo "  tail -f $TOMCAT_HOME/logs/catalina.out"
echo "Pour redémarrer:"
echo "  sudo systemctl restart tomcat9"