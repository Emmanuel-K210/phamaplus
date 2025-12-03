package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/auth/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Afficher le formulaire de réinitialisation
        request.setAttribute("pageTitle", "Mot de passe oublié");
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Validation de base
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Le nom d'utilisateur est requis");
                doGet(request, response);
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
                doGet(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Les mots de passe ne correspondent pas");
                doGet(request, response);
                return;
            }

            // Réinitialiser le mot de passe
            userService.resetPassword(username, newPassword);

            // Succès
            request.setAttribute("success", "Mot de passe réinitialisé avec succès ! Vous pouvez maintenant vous connecter.");
            request.setAttribute("username", username);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "Une erreur technique est survenue : " + e.getMessage());
        }

        // Réafficher le formulaire avec le message
        doGet(request, response);
    }
}