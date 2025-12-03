package com.onemaster.pharmaplus.filter;

import com.onemaster.pharmaplus.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    // Pages publiques (pas besoin d'authentification)
    private static final String[] PUBLIC_PAGES = {
            "/login",
            "/logout",
            "/register",
            "/forgot-password",      // AJOUTEZ CETTE LIGNE
            "/auth/forgot-password", // ET CETTE LIGNE POUR ÊTRE COMPLET
            "/error",
            "/index.jsp",
            "/resources/",
            "/css/",
            "/js/",
            "/images/",
            "/webjars/",
            "/favicon.ico"
    };

    // API/REST endpoints publics (si vous en avez)
    private static final String[] PUBLIC_API = {
            "/api/public/"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation si nécessaire
        System.out.println("AuthenticationFilter initialisé");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Récupérer le chemin de la requête
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        System.out.println("Filter checking path: " + path);

        // 1️⃣ Permettre l'accès aux JSP internes (forward depuis servlet)
        if (path.startsWith("/WEB-INF/") && path.endsWith(".jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // 2️⃣ Vérifier si c'est une page publique
        boolean isPublicPage = false;
        for (String publicPage : PUBLIC_PAGES) {
            if (path.startsWith(publicPage)) {
                isPublicPage = true;
                System.out.println("Public page detected: " + publicPage);
                break;
            }
        }

        // Vérifier les API publiques
        if (!isPublicPage) {
            for (String apiPath : PUBLIC_API) {
                if (path.startsWith(apiPath)) {
                    isPublicPage = true;
                    break;
                }
            }
        }

        // 3️⃣ Si page publique, laisser passer
        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 4️⃣ Redirection racine vers dashboard ou login
        if (path.equals("/") || path.equals("")) {
            if (session != null && session.getAttribute("user") != null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            }
            return;
        }

        // 5️⃣ Vérifier l'authentification
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("No session or user found, redirecting to login");

            // Stocker la page demandée pour redirection après login
            String redirectPath = path;

            // Ne pas stocker certaines pages sensibles
            if (!path.contains("delete") && !path.contains("edit") && !path.contains("add")) {
                session = httpRequest.getSession(true);
                session.setAttribute("redirectAfterLogin", redirectPath);
                System.out.println("Storing redirect path: " + redirectPath);
            }

            // Rediriger vers la page de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(path, "UTF-8"));
            return;
        }

        // 6️⃣ Vérifier les permissions (rôles)
        Object userObj = session.getAttribute("user");
        if (userObj instanceof User) {
            User user = (User) userObj;
            String userRole = user.getRole();

            // Vérification des rôles
            if (path.startsWith("/admin") && !"ADMIN".equals(userRole)) {
                System.out.println("Access denied for role " + userRole + " to path: " + path);
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Accès refusé. Cette page nécessite des privilèges administrateur.");
                return;
            }

            // Vous pouvez ajouter d'autres vérifications de rôle ici
            // Exemple: "/pharmacist", "/assistant", etc.
        }

        // 7️⃣ Vérifier si l'utilisateur est actif
        User user = (User) session.getAttribute("user");
        if (user != null && !user.getActive()) {
            System.out.println("User account is inactive: " + user.getUsername());
            session.invalidate();
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=Compte+désactivé");
            return;
        }

        // 8️⃣ Ajouter des en-têtes de sécurité
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");

        // 9️⃣ Continuer vers la ressource demandée
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
        System.out.println("AuthenticationFilter détruit");
    }
}