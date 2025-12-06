package com.onemaster.pharmaplus.filter;

import com.onemaster.pharmaplus.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthenticationFilter implements Filter {

    // Pages et ressources publiques (pas besoin d'authentification)
    private static final String[] PUBLIC_RESOURCES = {
            "/login",
            "/logout",
            "/register",
            "/forgot-password",
            "/auth/forgot-password",
            "/error",
            "/index.jsp",
            "/index.html",
            "/css/",
            "/js/",
            "/images/",
            "/fonts/",
            "/favicon.ico",
            "/webjars/",
            // API publiques
            "/api/public/",
            // Fichiers statiques spécifiques
            "/static/",
            "/resources/"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("=== AuthenticationFilter initialisé ===");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Récupérer le chemin de la requête
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Log pour débogage
        System.out.println("🔍 AuthenticationFilter - Path: " + path);
        System.out.println("🔍 AuthenticationFilter - Context Path: " + httpRequest.getContextPath());
        System.out.println("🔍 AuthenticationFilter - Full URI: " + httpRequest.getRequestURI());

        // 1️⃣ Vérifier si c'est une ressource publique (LAISSEZ PASSER IMMÉDIATEMENT)
        if (isPublicResource(path)) {
            System.out.println("✅ Ressource publique détectée: " + path);
            chain.doFilter(request, response);
            return;
        }

        // 2️⃣ Gestion spéciale pour la racine
        if (path.equals("/") || path.equals("")) {
            System.out.println("📌 Racine détectée");
            HttpSession session = httpRequest.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                System.out.println("➡️ Redirection vers dashboard");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
            } else {
                System.out.println("➡️ Redirection vers login");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            }
            return;
        }

        // 3️⃣ Vérifier l'authentification pour les autres pages
        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Aucune session ou utilisateur trouvé");

            // Stocker la page demandée pour redirection après login
            String redirectUrl = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                redirectUrl += "?" + httpRequest.getQueryString();
            }

            System.out.println("💾 Stockage de la redirection: " + redirectUrl);

            // Créer une nouvelle session pour stocker la redirection
            session = httpRequest.getSession(true);
            session.setAttribute("redirectAfterLogin", redirectUrl);

            // Rediriger vers la page de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // 4️⃣ Vérifier si l'utilisateur est actif
        User user = (User) session.getAttribute("user");
        if (user != null && !user.getActive()) {
            System.out.println("⚠️ Compte utilisateur inactif: " + user.getUsername());
            session.invalidate();
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=account_inactive");
            return;
        }

        // 5️⃣ Vérifier les permissions (rôles) - Optionnel
        if (user != null) {
            String userRole = user.getRole();

            // Vérification des rôles pour les pages admin
            if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(userRole)) {
                System.out.println("⛔ Accès refusé - Rôle " + userRole + " pour path: " + path);
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Accès refusé. Privilèges administrateur requis.");
                return;
            }

            // Vérifier si l'utilisateur a accès au dashboard
            if (path.equals("/dashboard") && !hasDashboardAccess(userRole)) {
                System.out.println("⛔ Accès refusé au dashboard pour rôle: " + userRole);
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Accès refusé au tableau de bord.");
                return;
            }
        }

        // 6️⃣ Ajouter des en-têtes de sécurité
        addSecurityHeaders(httpResponse);

        // 7️⃣ Continuer vers la ressource demandée
        System.out.println("✅ Accès autorisé pour: " + path);
        chain.doFilter(request, response);
    }

    /**
     * Vérifie si la ressource est publique
     */
    private boolean isPublicResource(String path) {
        // Toujours autoriser l'accès aux ressources statiques
        if (path.startsWith("/static/")) {
            return true;
        }

        // Vérifier les extensions de fichiers statiques
        if (path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") ||
                path.endsWith(".jpeg") || path.endsWith(".gif") ||
                path.endsWith(".ico") || path.endsWith(".svg") ||
                path.endsWith(".woff") || path.endsWith(".woff2") ||
                path.endsWith(".ttf") || path.endsWith(".eot")) {
            return true;
        }

        // Vérifier les chemins publics
        for (String publicResource : PUBLIC_RESOURCES) {
            if (path.startsWith(publicResource)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Vérifie si l'utilisateur a accès au dashboard
     */
    private boolean hasDashboardAccess(String role) {
        // Définir quels rôles ont accès au dashboard
        return "ADMIN".equalsIgnoreCase(role) ||
                "USER".equalsIgnoreCase(role) ||
                "PHARMACIST".equalsIgnoreCase(role) ||
                "ASSISTANT".equalsIgnoreCase(role);
    }

    /**
     * Ajoute des en-têtes de sécurité HTTP
     */
    private void addSecurityHeaders(HttpServletResponse response) {
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    @Override
    public void destroy() {
        System.out.println("=== AuthenticationFilter détruit ===");
    }
}