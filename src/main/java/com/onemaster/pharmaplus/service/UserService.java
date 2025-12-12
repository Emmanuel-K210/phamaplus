package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.UserDAOImpl;
import com.onemaster.pharmaplus.dao.service.UserDAO;
import com.onemaster.pharmaplus.model.User;

import java.util.List;

public class UserService {
    
    private final UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAOImpl();
    }

    public void resetPassword(String username, String newPassword) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom d'utilisateur est requis");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 6 caractères");
        }

        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }

        userDAO.changePassword(user.getId(), newPassword);
    }

    public User authenticate(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom d'utilisateur est requis");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Le mot de passe est requis");
        }
        
        return userDAO.authenticate(username.trim(), password.trim());
    }
    
    public void registerUser(User user) {
        validateUser(user);
        
        // Vérifier si l'username existe déjà
        User existing = userDAO.findByUsername(user.getUsername());
        if (existing != null) {
            throw new IllegalArgumentException("Ce nom d'utilisateur est déjà utilisé");
        }
        
        userDAO.insert(user);
    }
    
    public void updateUser(User user) {
        validateUser(user);
        userDAO.update(user);
    }
    
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 6 caractères");
        }
        
        // Vérifier l'ancien mot de passe
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }
        
        // Dans un vrai projet, vérifier le hash du currentPassword
        userDAO.changePassword(userId, newPassword);
    }
    
    public User getUserById(Long id) {
        return userDAO.findById(id);
    }
    
    public User getUserByUsername(String username) {
        return userDAO.findByUsername(username);
    }
    
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }
    
    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }
    
    public List<User> getActiveUsers() {
        return userDAO.findActiveUsers();
    }
    public List<User> getDesActiveUsers() {return userDAO.findDesaActiveUsers();}

    public int countAllUser() {return userDAO.countAll();}
    public int countAdmin(){return userDAO.countByRole("ADMIN");}
    public int countActiveUser(){return getActiveUsers().size();}
    public int countDesActiveUser(){return getDesActiveUsers().size();}
    public void deactivateUser(Long userId) {

        userDAO.toggleUserStatus(userId, false);
    }
    
    public void activateUser(Long userId) {
        userDAO.toggleUserStatus(userId, true);
    }
    
    public boolean isUsernameAvailable(String username) {
        return userDAO.findByUsername(username) == null;
    }
    
    private void validateUser(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom d'utilisateur est requis");
        }
        if (user.getUsername().length() < 3) {
            throw new IllegalArgumentException("Le nom d'utilisateur doit contenir au moins 3 caractères");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("Le mot de passe est requis");
        }
        if (user.getPassword().length() < 6) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 6 caractères");
        }
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom complet est requis");
        }
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            throw new IllegalArgumentException("Le rôle est requis");
        }
    }
}