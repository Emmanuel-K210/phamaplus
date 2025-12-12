package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.User;
import com.onemaster.pharmaplus.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            listUsers(request, response);
        } else {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    showUserDetails(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                default:
                    listUsers(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            listUsers(request, response);
        } else {
            switch (action) {
                case "create":
                    createUser(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    break;
                case "toggleStatus":
                    toggleUserStatus(request, response);
                    break;
                case "resetPassword":
                    resetPassword(request, response);
                    break;
                default:
                    listUsers(request, response);
            }
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userService.getAllUsers();
        int adminCount = userService.countAdmin();
        int inactiveCount = userService.countDesActiveUser();
        int activeCount = userService.countActiveUser();
        int userCount = userService.countAllUser();
        request.setAttribute("userCount", userCount);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("adminCount", adminCount);
        request.setAttribute("users", users);
        request.setAttribute("inactiveCount", inactiveCount);
        request.setAttribute("pageTitle", "Gestion des Utilisateurs");
        request.setAttribute("pageActive", "users");
        request.setAttribute("contentPage", "/WEB-INF/views/users/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] roles = {"ADMIN", "PHARMACIST", "CASHIER", "MANAGER", "ASSISTANT"};

        request.setAttribute("roles", roles);
        request.setAttribute("pageTitle", "Nouvel Utilisateur");
        request.setAttribute("pageActive", "users");
        request.setAttribute("contentPage", "/WEB-INF/views/users/add.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            User user = userService.getUserById(id);

            if (user == null) {
                request.setAttribute("error", "Utilisateur non trouvé");
                listUsers(request, response);
                return;
            }

            String[] roles = {"ADMIN", "PHARMACIST", "CASHIER", "MANAGER", "ASSISTANT"};

            request.setAttribute("user", user);
            request.setAttribute("roles", roles);
            request.setAttribute("pageTitle", "Modifier l'Utilisateur");
            request.setAttribute("pageActive", "users");
            request.setAttribute("contentPage", "/WEB-INF/views/users/edit.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID utilisateur invalide");
            listUsers(request, response);
        }
    }

    private void showUserDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            User user = userService.getUserById(id);

            if (user == null) {
                request.setAttribute("error", "Utilisateur non trouvé");
                listUsers(request, response);
                return;
            }

            request.setAttribute("user", user);
            request.setAttribute("pageTitle", "Détails de l'Utilisateur");
            request.setAttribute("pageActive", "users");
            request.setAttribute("contentPage", "/WEB-INF/views/users/view.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID utilisateur invalide");
            listUsers(request, response);
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setFullName(request.getParameter("fullName"));
            user.setRole(request.getParameter("role"));
            user.setActive(request.getParameter("active") != null);

            userService.registerUser(user);

            request.setAttribute("success", "Utilisateur créé avec succès !");
            listUsers(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showNewForm(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création de l'utilisateur");
            showNewForm(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            User user = userService.getUserById(id);

            if (user == null) {
                request.setAttribute("error", "Utilisateur non trouvé");
                listUsers(request, response);
                return;
            }

            user.setUsername(request.getParameter("username"));
            user.setFullName(request.getParameter("fullName"));
            user.setRole(request.getParameter("role"));
            user.setActive(request.getParameter("active") != null);

            userService.updateUser(user);

            request.setAttribute("success", "Utilisateur mis à jour avec succès !");
            listUsers(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la mise à jour de l'utilisateur");
            showEditForm(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            // Logique de suppression ou désactivation
            userService.deactivateUser(id);

            request.setAttribute("success", "Utilisateur désactivé avec succès !");
            listUsers(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID utilisateur invalide");
            listUsers(request, response);
        }
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            boolean active = Boolean.parseBoolean(request.getParameter("active"));

            if (active) {
                userService.activateUser(id);
                request.setAttribute("success", "Utilisateur activé avec succès !");
            } else {
                userService.deactivateUser(id);
                request.setAttribute("success", "Utilisateur désactivé avec succès !");
            }

            listUsers(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID utilisateur invalide");
            listUsers(request, response);
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Les mots de passe ne correspondent pas");
                showEditForm(request, response);
                return;
            }

            User user = userService.getUserById(id);
            if (user == null) {
                request.setAttribute("error", "Utilisateur non trouvé");
                listUsers(request, response);
                return;
            }

            userService.changePassword(id, "", newPassword); // À adapter selon votre logique

            request.setAttribute("success", "Mot de passe réinitialisé avec succès !");
            showEditForm(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la réinitialisation du mot de passe");
            showEditForm(request, response);
        }
    }
}