package com.onemaster.pharmaplus.utils;

import com.onemaster.pharmaplus.config.DatabaseConnection;

import java.sql.*;
import java.util.logging.Logger;

public class JdbcUtil {
    private static final Logger logger = Logger.getLogger(JdbcUtil.class.getName());

    /**
     * Ferme TOUTES les ressources JDBC
     */
    public static void closeAll(ResultSet rs, Statement stmt, Connection conn) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }

    public static void close(ResultSet rs, Statement stmt) {
        closeResultSet(rs);
        closeStatement(stmt);
        // Note: NE PAS fermer la connexion ici, car elle peut être réutilisée
    }

    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.warning("Erreur fermeture ResultSet: " + e.getMessage());
            }
        }
    }

    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                logger.warning("Erreur fermeture Statement: " + e.getMessage());
            }
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close(); // Avec HikariCP, retourne au pool
                }
            } catch (SQLException e) {
                logger.warning("Erreur fermeture Connection: " + e.getMessage());
            }
        }
    }

    /**
     * Méthode utilitaire pour exécuter avec try-with-resources
     */
    public static <T> T executeQuery(String sql, ResultSetHandler<T> handler, Object... params)
            throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            rs = stmt.executeQuery();
            return handler.handle(rs);

        } finally {
            closeAll(rs, stmt, conn);
        }
    }

    // Interface pour gérer les ResultSet
    @FunctionalInterface
    public interface ResultSetHandler<T> {
        T handle(ResultSet rs) throws SQLException;
    }
}