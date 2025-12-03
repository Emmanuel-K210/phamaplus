package com.onemaster.pharmapus.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // =====================================================
    // CONFIGURATION DE LA BASE DE DONNÉES
    // =====================================================
    private static final String URL = "jdbc:postgresql://localhost:5432/pharmaplus";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123";
    
    // =====================================================
    // PARAMÈTRES DE CONNEXION
    // =====================================================
    private static final int MAX_RETRIES = 3;
    private static final int RETRY_DELAY_MS = 1000;
    private static final int CONNECTION_TIMEOUT = 10; // secondes
    
    private static Connection connection = null;
    
    /**
     * Obtient une connexion à la base de données
     * @return Connection object
     */
    public static Connection getConnection() {
        if (connection == null || isConnectionClosed()) {
            connection = createConnectionWithRetry();
        }
        return connection;
    }
    
    /**
     * Crée une nouvelle connexion avec gestion des tentatives
     */
    private static Connection createConnectionWithRetry() {
        SQLException lastException = null;
        
        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                System.out.println("🔌 Tentative de connexion " + attempt + "/" + MAX_RETRIES + " à la base de données...");
                
                // Charger le driver PostgreSQL
                Class.forName("org.postgresql.Driver");
                
                // Établir la connexion avec timeout
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                
                // Configurer la connexion
                conn.setAutoCommit(true);
                
                // Tester la connexion
                if (conn.isValid(CONNECTION_TIMEOUT)) {
                    System.out.println("✅ Connexion à PostgreSQL établie avec succès!");
                    System.out.println("   Base: pharmaplus");
                    System.out.println("   Utilisateur: " + USER);
                    
                    // Afficher des informations sur la base
                    try (var stmt = conn.createStatement();
                         var rs = stmt.executeQuery("SELECT version()")) {
                        if (rs.next()) {
                            System.out.println("   PostgreSQL: " + rs.getString(1).split(",")[0]);
                        }
                    }
                    
                    return conn;
                }
                
            } catch (ClassNotFoundException e) {
                System.err.println("❌ Driver PostgreSQL non trouvé!");
                System.err.println("   Ajoutez-le dans pom.xml: <artifactId>postgresql</artifactId>");
                break;
                
            } catch (SQLException e) {
                lastException = e;
                System.err.println("❌ Échec de la connexion (tentative " + attempt + "): " + e.getMessage());
                
                if (attempt < MAX_RETRIES) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        }
        
        // Si on arrive ici, toutes les tentatives ont échoué
        System.err.println("💥 Impossible de se connecter à la base de données après " + MAX_RETRIES + " tentatives");
        if (lastException != null) {
            lastException.printStackTrace();
        }
        
        System.err.println("\n🔧 DÉPANNAGE:");
        System.err.println("1. Vérifiez que PostgreSQL est démarré:");
        System.err.println("   sudo systemctl status postgresql");
        System.err.println("2. Vérifiez les identifiants dans DatabaseConnection.java");
        System.err.println("3. Testez la connexion manuellement:");
        System.err.println("   psql -h localhost -U " + USER + " -d pharmaplus");
        System.err.println("4. Créez la base si elle n'existe pas:");
        System.err.println("   psql -U " + USER + " -f database/setup.sql");
        
        return null;
    }
    
    /**
     * Vérifie si la connexion est fermée
     */
    private static boolean isConnectionClosed() {
        try {
            return connection == null || connection.isClosed();
        } catch (SQLException e) {
            return true;
        }
    }
    
    /**
     * Ferme la connexion à la base de données
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("🔌 Connexion à la base de données fermée");
                }
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture de la connexion: " + e.getMessage());
            } finally {
                connection = null;
            }
        }
    }
    
    /**
     * Teste la connexion (pour débogage)
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null && conn.isValid(5)) {
                System.out.println("✅ Test de connexion réussi");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Test de connexion échoué: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Récupère des informations sur la base
     */
    public static void printDatabaseInfo() {
        try (Connection conn = getConnection();
             var stmt = conn.createStatement()) {
            
            // Nombre de tables
            var rs = stmt.executeQuery(
                "SELECT COUNT(*) FROM information_schema.tables " +
                "WHERE table_schema = 'public'"
            );
            if (rs.next()) {
                System.out.println("📊 Tables dans la base: " + rs.getInt(1));
            }
            
            // Statistiques des principales tables
            String[] tables = {"products", "inventory", "customers", "sales", "users"};
            System.out.println("\n📈 Statistiques:");
            for (String table : tables) {
                try {
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table);
                    if (rs.next()) {
                        System.out.println(String.format("   %-12s: %6d enregistrements", table, rs.getInt(1)));
                    }
                } catch (SQLException e) {
                    // Table peut ne pas exister
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des informations: " + e.getMessage());
        }
    }
}