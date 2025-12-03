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
        echo "   Démarrez-le avec: sudo systemctl