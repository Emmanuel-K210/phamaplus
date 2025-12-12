package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.service.UserService;
import com.onemaster.pharmaplus.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {
    "/login",
    "/logout",
    "/register",
    "/profile",
    "/change-password"
})
public class LoginServlet extends HttpServlet {
    
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/change-password":
                showChangePasswordForm(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        if ("/login".equals(action)) {
            processLogin(request, response);
        } else if ("/register".equals(action)) {
            processRegistration(request, response);
        } else if ("/change-password".equals(action)) {
            processChangePassword(request, response);
        } else if ("/profile".equals(action)) {
            updateProfile(request, response);
        }
    }
    
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier si déjà connecté
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
    
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            User user = userService.authenticate(username, password);
            
            if (user != null) {
                // Créer la session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("fullName", user.getFullName());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Vérifier s'il y a une redirection stockée
                String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            } else {
                request.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
                showLoginForm(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showLoginForm(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }
    
    private void processRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setFullName(request.getParameter("fullName"));
            user.setRole("PHARMACIST"); // Par défaut
            
            userService.registerUser(user);
            
            // Auto-login après inscription
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("isAdmin", "ADMIN".equals(user.getRole()));
            
            response.sendRedirect(request.getContextPath() + "/dashboard?success=Compte+créé+avec+succès");
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showRegisterForm(request, response);
        }
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        User user = userService.getUserById(currentUser.getId());
        
        request.setAttribute("user", user);
        request.setAttribute("pageTitle", "Profile");
        request.setAttribute("contentPage", "/WEB-INF/views/auth/profile.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            User currentUser = (User) session.getAttribute("user");
            User user = userService.getUserById(currentUser.getId());
            
            user.setFullName(request.getParameter("fullName"));
            
            userService.updateUser(user);
            
            // Mettre à jour la session
            session.setAttribute("user", user);
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("isAdmin", "ADMIN".equals(user.getRole()));
            
            response.sendRedirect(request.getContextPath() + "/profile?success=Profil+mis+à+jour");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showProfile(request, response);
        }
    }
    
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("pageTitle", "Modifier mot de passe");
        request.setAttribute("contentPage", "/WEB-INF/views/auth/change-password.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

    }
    
    private void processChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            User currentUser = (User) session.getAttribute("user");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (!newPassword.equals(confirmPassword)) {
                throw new IllegalArgumentException("Les nouveaux mots de passe ne correspondent pas");
            }
            
            // Vérifier l'ancien mot de passe (simplifié)
            User user = userService.authenticate(currentUser.getUsername(), currentPassword);
            if (user == null) {
                throw new IllegalArgumentException("Mot de passe actuel incorrect");
            }
            
            userService.changePassword(currentUser.getId(), currentPassword, newPassword);
            
            response.sendRedirect(request.getContextPath() + "/profile?success=Mot+de+passe+changé");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showChangePasswordForm(request, response);
        }
    }
}