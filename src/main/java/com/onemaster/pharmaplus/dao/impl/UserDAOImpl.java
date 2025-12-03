package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.UserDAO;
import com.onemaster.pharmaplus.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    
    private Connection connection;
    
    public UserDAOImpl() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    @Override
    public void insert(User user) {
        String sql = "INSERT INTO users (username, password, full_name, role, active) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, hashPassword(user.getPassword())); // Hash du mot de passe
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.getActive() != null ? user.getActive() : true);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getLong(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur insertion utilisateur: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND active = TRUE";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    
                    // Vérifier le mot de passe (hash simple pour l'exemple)
                    if (storedHash.equals(hashPassword(password))) {
                        User user = mapUser(rs);
                        
                        // Mettre à jour la dernière connexion
                        updateLastLogin(user.getId());
                        
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur authentification: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur recherche utilisateur: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public void updateLastLogin(Long userId) {
        String sql = "UPDATE users SET last_login = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur mise à jour dernière connexion: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void changePassword(Long userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, hashPassword(newPassword));
            stmt.setLong(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur changement mot de passe: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Méthodes de hashage simples (À améliorer avec BCrypt en production)
    private String hashPassword(String password) {
        // Hash SHA-256 simple (en production, utiliser BCrypt)
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (Exception e) {
            return password; // Fallback (NE PAS FAIRE EN PRODUCTION)
        }
    }
    
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password")); // Hashé
        user.setFullName(rs.getString("full_name"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("active"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp lastLogin = rs.getTimestamp("last_login");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }
        
        return user;
    }

    // Méthodes restantes
    @Override
    public void update(User user) {
        String sql = "UPDATE users SET full_name = ?, role = ?, active = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getRole());
            stmt.setBoolean(3, user.getActive());
            stmt.setLong(4, user.getId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public User findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY username";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> findByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY username";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> findActiveUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE active = TRUE ORDER BY username";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void toggleUserStatus(Long userId, boolean active) {
        String sql = "UPDATE users SET active = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, active);
            stmt.setLong(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}