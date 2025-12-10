package com.onemaster.pharmaplus.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DatabaseConnection {
    private static final Logger logger = Logger.getLogger(DatabaseConnection.class.getName());

    // Configuration
    private static final String URL = "jdbc:postgresql://localhost:5432/pharmaplus";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123";
    private static final int MAX_RETRIES = 3;
    private static final int RETRY_DELAY_MS = 1000;
    private static final int CONNECTION_TIMEOUT = 10;

    // Variable locale par thread pour éviter les conflits
    private static final ThreadLocal<Connection> threadLocalConnection = new ThreadLocal<>();

    static {
        try {
            Class.forName("org.postgresql.Driver");
            logger.info("Driver PostgreSQL chargé avec succès");
        } catch (ClassNotFoundException e) {
            logger.severe("❌ Driver PostgreSQL non trouvé!");
            throw new RuntimeException("Driver PostgreSQL non trouvé", e);
        }
    }

    /**
     * Obtient une connexion à la base de données (une par thread)
     */
    public static Connection getConnection() {
        Connection conn = threadLocalConnection.get();

        try {
            if (conn == null || conn.isClosed() || !conn.isValid(2)) {
                logger.info("Création d'une nouvelle connexion pour le thread: " + Thread.currentThread().getId());
                conn = createConnectionWithRetry();
                threadLocalConnection.set(conn);
            }
        } catch (SQLException e) {
            logger.warning("Connexion invalide, création d'une nouvelle: " + e.getMessage());
            conn = createConnectionWithRetry();
            threadLocalConnection.set(conn);
        }

        return conn;
    }

    /**
     * Crée une nouvelle connexion avec gestion des tentatives
     */
    private static Connection createConnectionWithRetry() {
        SQLException lastException = null;

        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                logger.info("Tentative de connexion " + attempt + "/" + MAX_RETRIES);

                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

                // Configuration importante
                conn.setAutoCommit(true); // Auto-commit par défaut
                conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

                // Tester la connexion
                if (conn.isValid(CONNECTION_TIMEOUT)) {
                    logger.info("✅ Connexion établie avec succès!");
                    return conn;
                }

            } catch (SQLException e) {
                lastException = e;
                logger.warning("❌ Échec de la connexion (tentative " + attempt + "): " + e.getMessage());

                if (attempt < MAX_RETRIES) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new RuntimeException("Connexion interrompue", ie);
                    }
                }
            }
        }

        logger.severe("💥 Impossible de se connecter après " + MAX_RETRIES + " tentatives");
        if (lastException != null) {
            lastException.printStackTrace();
        }

        throw new RuntimeException("Erreur de connexion à la base de données");
    }

    /**
     * Ferme la connexion du thread courant
     */
    public static void closeConnection() {
        Connection conn = threadLocalConnection.get();
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    logger.info("Connexion fermée pour le thread: " + Thread.currentThread().getId());
                }
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture de la connexion: " + e.getMessage());
            } finally {
                threadLocalConnection.remove(); // Important: retirer du ThreadLocal
            }
        }
    }

    /**
     * Ferme la connexion et retire du ThreadLocal
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    logger.info("Connexion fermée");
                }
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture de la connexion: " + e.getMessage());
            }
        }
        threadLocalConnection.remove();
    }

    /**
     * Vérifie si la connexion courante est valide
     */
    public static boolean isConnectionValid() {
        Connection conn = threadLocalConnection.get();
        if (conn != null) {
            try {
                return conn.isValid(2);
            } catch (SQLException e) {
                return false;
            }
        }
        return false;
    }

    /**
     * Teste la connexion (méthode utilitaire)
     */
    public static boolean testConnection() {
        try (Connection testConn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            boolean valid = testConn.isValid(5);
            logger.info("Test de connexion: " + (valid ? "✅ SUCCÈS" : "❌ ÉCHEC"));
            return valid;
        } catch (SQLException e) {
            logger.severe("Test de connexion échoué: " + e.getMessage());
            return false;
        }
    }

    /**
     * Ouvre une transaction (désactive auto-commit)
     */
    public static void beginTransaction() throws SQLException {
        Connection conn = getConnection();
        if (conn.getAutoCommit()) {
            conn.setAutoCommit(false);
            logger.fine("Transaction démarrée");
        }
    }

    /**
     * Valide la transaction
     */
    public static void commit() throws SQLException {
        Connection conn = threadLocalConnection.get();
        if (conn != null && !conn.getAutoCommit()) {
            conn.commit();
            conn.setAutoCommit(true); // Rétablir auto-commit
            logger.fine("Transaction validée");
        }
    }

    /**
     * Annule la transaction
     */
    public static void rollback() {
        Connection conn = threadLocalConnection.get();
        if (conn != null) {
            try {
                if (!conn.getAutoCommit()) {
                    conn.rollback();
                    conn.setAutoCommit(true); // Rétablir auto-commit
                    logger.fine("Transaction annulée");
                }
            } catch (SQLException e) {
                logger.warning("Erreur lors du rollback: " + e.getMessage());
            }
        }
    }

    /**
     * Nettoie les connexions (à appeler à la fin de chaque requête)
     */
    public static void cleanup() {
        closeConnection();
    }
}