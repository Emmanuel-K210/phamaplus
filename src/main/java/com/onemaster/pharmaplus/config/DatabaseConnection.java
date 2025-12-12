package com.onemaster.pharmaplus.config;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Logger;

public class DatabaseConnection {
    private static final Logger logger = Logger.getLogger(DatabaseConnection.class.getName());

    // Configuration par défaut (backup)
    private static final Properties config = new Properties();
    private static boolean configLoaded = false;

    static {
        loadConfiguration();
        loadDriver();
    }

    /**
     * Charge la configuration depuis plusieurs sources
     */
    private static void loadConfiguration() {
        // 1. ESSAYEZ D'ABORD LES VARIABLES D'ENVIRONNEMENT
        // C'est ce qui se passe actuellement - "utilisation des variables d'environnement"

        // 2. CHARGEZ UN FICHIER .env DEPUIS LE CLASSPATH (WEB-INF/.env)
        try (InputStream input = DatabaseConnection.class.getClassLoader()
                .getResourceAsStream(".env")) {
            if (input != null) {
                config.load(input);
                configLoaded = true;
                logger.info("✅ Fichier .env chargé depuis le classpath (WEB-INF/.env)");
            } else {
                logger.info("ℹ️ Fichier .env non trouvé dans WEB-INF/.env");
            }
        } catch (IOException e) {
            logger.warning("⚠️ Impossible de charger .env: " + e.getMessage());
        }

        // Affiche la source de configuration
        if (configLoaded) {
            logger.info("Configuration source: fichier .env");
        } else {
            logger.info("Configuration source: variables d'environnement/valeurs par défaut");
        }
    }

    /**
     * Charge le driver PostgreSQL
     */
    private static void loadDriver() {
        try {
            Class.forName("org.postgresql.Driver");
            logger.info("✅ Driver PostgreSQL chargé");
        } catch (ClassNotFoundException e) {
            logger.severe("❌ Driver PostgreSQL NON TROUVÉ");
            throw new RuntimeException("Driver PostgreSQL manquant. Vérifiez WEB-INF/lib/", e);
        }
    }

    /**
     * Récupère une valeur de configuration CORRIGÉE
     */
    private static String getConfigValue(String key, String defaultValue) {
        // Évite les logs null qui causent l'erreur
        String value = null;
        String source = "";

        // PRIORITÉ 1: Variable d'environnement système
        value = System.getenv(key);
        if (value != null && !value.trim().isEmpty()) {
            source = "env";
        }

        // PRIORITÉ 2: Fichier .env dans le classpath
        if ((value == null || value.trim().isEmpty()) && configLoaded) {
            value = config.getProperty(key);
            if (value != null && !value.trim().isEmpty()) {
                source = "file";
            }
        }

        // PRIORITÉ 3: Valeur par défaut
        if (value == null || value.trim().isEmpty()) {
            value = defaultValue;
            source = "default";
        }

        // Log sécurisé (sans valeurs sensibles)
        if (key.toLowerCase().contains("password")) {
            logger.fine("Config " + key + " chargée depuis: " + source);
        } else {
            logger.fine("Config " + key + " = " + value + " (source: " + source + ")");
        }

        return value.trim();
    }

    /**
     * Construit l'URL JDBC avec valeurs par défaut robustes
     */
    private static String buildJdbcUrl() {
        // Valeurs par défaut explicites
        String host = getConfigValue("DB_HOST", "localhost");
        String port = getConfigValue("DB_PORT", "5432");
        String name = getConfigValue("DB_NAME", "pharmaplus");
        String ssl = getConfigValue("DB_SSLMODE", "disable");

        // Validation des valeurs
        if (host == null) host = "localhost";
        if (port == null) port = "5432";
        if (name == null) name = "pharmaplus";
        if (ssl == null) ssl = "disable";

        String url = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s",
                host, port, name, ssl);

        logger.fine("URL JDBC construite: " + url.replace("//", "//***:***@"));
        return url;
    }

    /**
     * Obtient une connexion - VERSION SIMPLIFIÉE ET ROBUSTE
     */
    public static Connection getConnection() throws SQLException {
        // Construction de l'URL avec valeurs garanties non-null
        String url = buildJdbcUrl();

        // Utilisateur avec valeur par défaut explicite
        String user = getConfigValue("DB_USER", "postgres");
        if (user == null || user.trim().isEmpty()) {
            user = "postgres";
        }

        // Mot de passe avec valeur par défaut
        String password = getConfigValue("DB_PASSWORD", "CSUSP2025");
        if (password == null) {
            password = "";
        }

        // Debug
        logger.info("Connexion à PostgreSQL: " +
                url.replace("jdbc:postgresql://", "").split("/")[0] +
                " (user: " + user + ")");

        // Connexion simple
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Test de connexion amélioré
     */
    public static boolean testConnection() {
        logger.info("=== Début test connexion ===");

        try (Connection conn = getConnection()) {
            boolean valid = conn.isValid(3);
            if (valid) {
                logger.info("✅ Connexion PostgreSQL RÉUSSIE");

                // Test supplémentaire
                try (var stmt = conn.createStatement();
                     var rs = stmt.executeQuery("SELECT 1 as test")) {
                    if (rs.next()) {
                        logger.info("✅ Requête de test exécutée avec succès");
                    }
                }
                return true;
            } else {
                logger.warning("⚠️ Connexion établie mais invalide");
                return false;
            }
        } catch (SQLException e) {
            logger.severe("❌ ERREUR Connexion: " + e.getMessage());
            logger.severe("Code erreur: " + e.getErrorCode());
            logger.severe("SQL State: " + e.getSQLState());
            return false;
        } finally {
            logger.info("=== Fin test connexion ===");
        }
    }

    /**
     * Affiche la configuration actuelle
     */
    public static void printCurrentConfig() {
        String url = buildJdbcUrl();
        String user = getConfigValue("DB_USER", "postgres");

        logger.info("=== Configuration active ===");
        logger.info("URL: " + url.replace("//", "//***:***@"));
        logger.info("User: " + user);
        logger.info("Source config: " + (configLoaded ? "fichier .env" : "variables/env"));
        logger.info("============================");
    }
}