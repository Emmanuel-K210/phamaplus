package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.ApplicationParameter;
import com.onemaster.pharmaplus.service.ApplicationParameterService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/settings", "/settings/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1 MB
        maxFileSize = 1024 * 1024 * 5,      // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class SettingsServlet extends HttpServlet {

    private ApplicationParameterService parameterService;
    private Gson gson;

    @Override
    public void init() {
        parameterService = new ApplicationParameterService();
        gson = new GsonBuilder()
                .setPrettyPrinting()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "/general":
                    showGeneralSettings(request, response);
                    break;
                case "/ui":
                    showUISettings(request, response);
                    break;
                case "/financial":
                    showFinancialSettings(request, response);
                    break;
                case "/notifications":
                    showNotificationSettings(request, response);
                    break;
                case "/security":
                    showSecuritySettings(request, response);
                    break;
                case "/advanced":
                    showAdvancedSettings(request, response);
                    break;
                case "/export":
                    exportSettings(request, response);
                    break;
                default:
                    showAllSettings(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/settings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "/save":
                    saveSettings(request, response);
                    break;
                case "/reset":
                    resetSettings(request, response);
                    break;
                case "/import":
                    importSettings(request, response);
                    break;
                case "/update-single":
                    updateSingleParameter(request, response);
                    break;
                default:
                    showAllSettings(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/settings");
        }
    }


    // ============ AFFICHAGE DES PARAMÈTRES PAR CATÉGORIE ============

    /**
     * Affiche tous les paramètres
     */
    private void showAllSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("=== DEBUG SettingsServlet.showAllSettings ===");

            // Récupérer la catégorie depuis les paramètres
            String category = request.getParameter("category");
            System.out.println("Catégorie demandée: " + category);

            // Récupérer les paramètres
            List<ApplicationParameter> allParameters;
            if (category != null && !category.trim().isEmpty()) {
                allParameters = parameterService.getParametersByCategory(category);
            } else {
                allParameters = parameterService.getAllParameters();
            }

            System.out.println("Paramètres trouvés: " + allParameters.size());

            // Récupérer toutes les catégories uniques
            List<String> categories = allParameters.stream()
                    .map(ApplicationParameter::getCategory)
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList());

            // Définir les attributs
            request.setAttribute("parameters", allParameters);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Paramètres de l'application");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/list.jsp");

            // Ajouter la date actuelle
            request.setAttribute("now", new java.util.Date());

            // Transfert vers la page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("ERREUR dans showAllSettings: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des paramètres", e);
        }
    }

    /**
     * Affiche les paramètres généraux (nom pharmacie, adresse, etc.)
     */
    private void showGeneralSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> generalParams = parameterService.getParametersByCategory("GENERAL");

            request.setAttribute("parameters", generalParams);
            request.setAttribute("category", "GENERAL");
            request.setAttribute("categoryName", "Paramètres Généraux");
            request.setAttribute("categoryDescription", "Configuration générale de la pharmacie");
            request.setAttribute("pageTitle", "Paramètres Généraux");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres généraux", e);
        }
    }

    /**
     * Affiche les paramètres d'interface utilisateur
     */
    private void showUISettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> uiParams = parameterService.getParametersByCategory("UI");

            request.setAttribute("parameters", uiParams);
            request.setAttribute("category", "UI");
            request.setAttribute("categoryName", "Paramètres Interface");
            request.setAttribute("categoryDescription", "Personnalisation de l'interface utilisateur");
            request.setAttribute("pageTitle", "Paramètres Interface");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres UI", e);
        }
    }

    /**
     * Affiche les paramètres financiers (taxes, arrondissement, etc.)
     */
    private void showFinancialSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> financialParams = parameterService.getParametersByCategory("FINANCIAL");

            request.setAttribute("parameters", financialParams);
            request.setAttribute("category", "FINANCIAL");
            request.setAttribute("categoryName", "Paramètres Financiers");
            request.setAttribute("categoryDescription", "Configuration des taxes, devises et options financières");
            request.setAttribute("pageTitle", "Paramètres Financiers");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres financiers", e);
        }
    }

    /**
     * Affiche les paramètres de notifications
     */
    private void showNotificationSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> notificationParams = parameterService.getParametersByCategory("NOTIFICATION");

            request.setAttribute("parameters", notificationParams);
            request.setAttribute("category", "NOTIFICATION");
            request.setAttribute("categoryName", "Paramètres Notifications");
            request.setAttribute("categoryDescription", "Configuration des alertes et notifications");
            request.setAttribute("pageTitle", "Paramètres Notifications");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres de notification", e);
        }
    }

    /**
     * Affiche les paramètres de sécurité
     */
    private void showSecuritySettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> securityParams = parameterService.getParametersByCategory("SECURITY");

            request.setAttribute("parameters", securityParams);
            request.setAttribute("category", "SECURITY");
            request.setAttribute("categoryName", "Paramètres Sécurité");
            request.setAttribute("categoryDescription", "Configuration de la sécurité et des accès");
            request.setAttribute("pageTitle", "Paramètres Sécurité");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres de sécurité", e);
        }
    }

    /**
     * Affiche les paramètres avancés
     */
    private void showAdvancedSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> advancedParams = parameterService.getParametersByCategory("ADVANCED");

            request.setAttribute("parameters", advancedParams);
            request.setAttribute("category", "ADVANCED");
            request.setAttribute("categoryName", "Paramètres Avancés");
            request.setAttribute("categoryDescription", "Configuration avancée du système");
            request.setAttribute("pageTitle", "Paramètres Avancés");
            request.setAttribute("contentPage", "/WEB-INF/views/settings/category.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des paramètres avancés", e);
        }
    }

    // ============ SAUVEGARDE ET MODIFICATION ============

    /**
     * Sauvegarde tous les paramètres modifiés
     */
    private void saveSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<ApplicationParameter> allParameters = parameterService.getAllParameters();
            int updatedCount = 0;
            List<String> errors = new ArrayList<>();

            for (ApplicationParameter param : allParameters) {
                String paramValue = request.getParameter(param.getParameterKey());

                if (paramValue != null && !paramValue.equals(param.getParameterValue())) {
                    // Valider la valeur
                    if (validateParameterValue(param, paramValue)) {
                        param.setParameterValue(paramValue);
                        parameterService.saveParameter(param);
                        updatedCount++;
                    } else {
                        errors.add("Valeur invalide pour " + param.getParameterKey());
                    }
                }
            }

            String redirectUrl = request.getContextPath() + "/settings";
            String category = request.getParameter("category");
            if (category != null && !category.trim().isEmpty()) {
                redirectUrl += "/" + category.toLowerCase();
            }

            if (errors.isEmpty()) {
                redirectUrl += "?success=" + URLEncoder.encode(
                        updatedCount + " paramètre(s) sauvegardé(s) avec succès",
                        StandardCharsets.UTF_8);
            } else {
                redirectUrl += "?warning=" + URLEncoder.encode(
                        updatedCount + " paramètre(s) sauvegardé(s), " + errors.size() + " erreur(s)",
                        StandardCharsets.UTF_8);
            }

            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/settings?error=" + URLEncoder.encode(
                    "Erreur lors de la sauvegarde: " + e.getMessage(),
                    StandardCharsets.UTF_8));
        }
    }

    /**
     * Met à jour un seul paramètre (pour les requêtes AJAX)
     */
    private void updateSingleParameter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String key = request.getParameter("key");
            String value = request.getParameter("value");

            if (key == null || value == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Paramètres manquants\"}");
                return;
            }

            ApplicationParameter param = parameterService.getParameterByKey(key);

            if (param == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Paramètre non trouvé\"}");
                return;
            }

            if (!validateParameterValue(param, value)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Valeur invalide\"}");
                return;
            }

            param.setParameterValue(value);
            parameterService.saveParameter(param);

            out.print("{\"success\":true,\"message\":\"Paramètre mis à jour\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Réinitialise les paramètres aux valeurs par défaut
     */
    private void resetSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String category = request.getParameter("category");
            String confirm = request.getParameter("confirm");

            // Vérification de confirmation
            if (!"true".equals(confirm)) {
                response.sendRedirect(request.getContextPath() +
                        "/settings?error=" + URLEncoder.encode(
                        "Confirmation requise pour la réinitialisation",
                        StandardCharsets.UTF_8));
                return;
            }

            if (category != null && !category.trim().isEmpty()) {
                // Réinitialiser une catégorie spécifique
                List<ApplicationParameter> params = parameterService.getParametersByCategory(category);
                for (ApplicationParameter param : params) {
                    String defaultValue = getDefaultValue(param.getParameterKey());
                    if (defaultValue != null) {
                        param.setParameterValue(defaultValue);
                        parameterService.saveParameter(param);
                    }
                }

                response.sendRedirect(request.getContextPath() +
                        "/settings/" + category.toLowerCase() +
                        "?success=" + URLEncoder.encode(
                        "Paramètres de la catégorie " + category + " réinitialisés",
                        StandardCharsets.UTF_8));
            } else {
                // Réinitialiser tous les paramètres
                parameterService.initializeDefaultParameters();

                response.sendRedirect(request.getContextPath() +
                        "/settings?success=" + URLEncoder.encode(
                        "Tous les paramètres ont été réinitialisés",
                        StandardCharsets.UTF_8));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/settings?error=" + URLEncoder.encode(
                    "Erreur lors de la réinitialisation: " + e.getMessage(),
                    StandardCharsets.UTF_8));
        }
    }

    // ============ IMPORT / EXPORT ============

    /**
     * Exporte les paramètres en JSON
     */
    private void exportSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String category = request.getParameter("category");
            List<ApplicationParameter> parameters;

            if (category != null && !category.trim().isEmpty()) {
                parameters = parameterService.getParametersByCategory(category);
            } else {
                parameters = parameterService.getAllParameters();
            }

            // Créer un objet d'export avec métadonnées
            Map<String, Object> exportData = new LinkedHashMap<>();
            exportData.put("exportDate", new java.util.Date());
            exportData.put("version", "1.0");
            exportData.put("category", category != null ? category : "ALL");
            exportData.put("parameters", parameters);

            String json = gson.toJson(exportData);

            // Configurer la réponse pour le téléchargement
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String filename = "pharmaplus_settings_" +
                    (category != null ? category.toLowerCase() + "_" : "") +
                    System.currentTimeMillis() + ".json";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            throw new ServletException("Erreur lors de l'export des paramètres", e);
        }
    }

    /**
     * Importe les paramètres depuis un fichier JSON
     */
    private void importSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Part filePart = request.getPart("file");

            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() +
                        "/settings?error=" + URLEncoder.encode(
                        "Aucun fichier sélectionné",
                        StandardCharsets.UTF_8));
                return;
            }

            // Vérifier le type de fichier
            String contentType = filePart.getContentType();
            if (!contentType.equals("application/json")) {
                response.sendRedirect(request.getContextPath() +
                        "/settings?error=" + URLEncoder.encode(
                        "Format de fichier invalide. Seuls les fichiers JSON sont acceptés",
                        StandardCharsets.UTF_8));
                return;
            }

            // Lire le contenu du fichier
            InputStream fileContent = filePart.getInputStream();
            String jsonContent = new BufferedReader(new InputStreamReader(fileContent, StandardCharsets.UTF_8))
                    .lines()
                    .collect(Collectors.joining("\n"));

            // Parser le JSON
            @SuppressWarnings("unchecked")
            Map<String, Object> importData = gson.fromJson(jsonContent, Map.class);

            if (!importData.containsKey("parameters")) {
                response.sendRedirect(request.getContextPath() +
                        "/settings?error=" + URLEncoder.encode(
                        "Format de fichier invalide",
                        StandardCharsets.UTF_8));
                return;
            }

            // Importer les paramètres
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> parameters = (List<Map<String, Object>>) importData.get("parameters");
            int importedCount = 0;

            for (Map<String, Object> paramMap : parameters) {
                String key = (String) paramMap.get("parameterKey");
                String value = (String) paramMap.get("parameterValue");

                if (key != null && value != null) {
                    ApplicationParameter param = parameterService.getParameterByKey(key);
                    if (param != null && validateParameterValue(param, value)) {
                        param.setParameterValue(value);
                        parameterService.saveParameter(param);
                        importedCount++;
                    }
                }
            }

            response.sendRedirect(request.getContextPath() +
                    "/settings?success=" + URLEncoder.encode(
                    importedCount + " paramètre(s) importé(s) avec succès",
                    StandardCharsets.UTF_8));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/settings?error=" + URLEncoder.encode(
                    "Erreur lors de l'import: " + e.getMessage(),
                    StandardCharsets.UTF_8));
        }
    }

    // ============ MÉTHODES UTILITAIRES ============

    /**
     * Extrait les catégories uniques des paramètres
     */
    private List<String> getUniqueCategories(List<ApplicationParameter> parameters) {
        return parameters.stream()
                .map(ApplicationParameter::getCategory)
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    /**
     * Valide la valeur d'un paramètre selon son type de données
     */
    private boolean validateParameterValue(ApplicationParameter param, String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }

        String dataType = param.getDataType();

        try {
            switch (dataType) {
                case "INTEGER":
                    Integer.parseInt(value);
                    return true;

                case "DECIMAL":
                    Double.parseDouble(value);
                    return true;

                case "BOOLEAN":
                    return value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false");

                case "EMAIL":
                    return value.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

                case "PHONE":
                    return value.matches("^[0-9+\\-\\s()]+$");

                case "URL":
                    return value.matches("^(https?://)?[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}.*$");

                case "STRING":
                case "TEXT":
                default:
                    return true;
            }
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Obtient la valeur par défaut d'un paramètre
     */
    private String getDefaultValue(String key) {
        // Map des valeurs par défaut
        Map<String, String> defaults = new HashMap<>();

        // GENERAL
        defaults.put("pharmacy_name", "PharmaMaster");
        defaults.put("pharmacy_address", "");
        defaults.put("pharmacy_phone", "");
        defaults.put("pharmacy_email", "");
        defaults.put("business_hours", "8:00-18:00");

        // UI
        defaults.put("theme", "light");
        defaults.put("language", "fr");
        defaults.put("date_format", "dd/MM/yyyy");
        defaults.put("items_per_page", "10");

        // FINANCIAL
        defaults.put("default_currency", "XOF");
        defaults.put("tax_rate", "0");
        defaults.put("enable_discount", "true");
        defaults.put("max_discount_percentage", "20");

        // NOTIFICATION
        defaults.put("low_stock_alert", "true");
        defaults.put("low_stock_threshold", "10");
        defaults.put("expiry_alert_days", "30");

        // SECURITY
        defaults.put("session_timeout", "30");
        defaults.put("password_min_length", "6");
        defaults.put("enable_two_factor", "false");

        return defaults.get(key);
    }

    /**
     * Gère les erreurs et redirige avec un message approprié
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                             Exception e, String redirectPath)
            throws ServletException, IOException {

        e.printStackTrace();

        if (response.isCommitted()) {
            return;
        }

        String errorMessage = "Erreur : " + e.getMessage();
        response.sendRedirect(request.getContextPath() + redirectPath +
                "?error=" + URLEncoder.encode(errorMessage, StandardCharsets.UTF_8));
    }
}