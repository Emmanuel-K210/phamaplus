package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.User;
import java.util.List;

public interface UserDAO {
    // CRUD
    void insert(User user);
    void update(User user);
    void delete(Long id);
    User findById(Long id);
    User findByUsername(String username);
    List<User> findAll();
    
    // Authentification
    User authenticate(String username, String password);
    
    // Recherches
    List<User> findByRole(String role);
    List<User> findActiveUsers();
    
    // Statistiques
    int countAll();
    int countByRole(String role);
    
    // Mise à jour
    void updateLastLogin(Long userId);
    void changePassword(Long userId, String newPassword);
    void toggleUserStatus(Long userId, boolean active);
}