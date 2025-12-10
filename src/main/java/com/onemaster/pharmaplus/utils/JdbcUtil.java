package com.onemaster.pharmaplus.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

public class JdbcUtil {
    private static final Logger logger = Logger.getLogger(JdbcUtil.class.getName());

    /**
     * Ferme les ressources JDBC en ordre inverse
     */
    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        close(rs);
        close(stmt);
        close(conn);
    }

    public static void close(ResultSet rs, Statement stmt) {
        close(rs);
        close(stmt);
    }

    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture du ResultSet: " + e.getMessage());
            }
        }
    }

    public static void close(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture du Statement: " + e.getMessage());
            }
        }
    }

    public static void close(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture de la Connection: " + e.getMessage());
            }
        }
    }

    /**
     * Rétablit auto-commit et ferme la connexion
     */
    public static void safeClose(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.getAutoCommit()) {
                    conn.setAutoCommit(true);
                }
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                logger.warning("Erreur lors de la fermeture sécurisée: " + e.getMessage());
            }
        }
    }

    /**
     * Vérifie si une connexion est valide
     */
    public static boolean isValidConnection(Connection conn) {
        if (conn == null) return false;
        try {
            return conn.isValid(2);
        } catch (SQLException e) {
            return false;
        }
    }
}