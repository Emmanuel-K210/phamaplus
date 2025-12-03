package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.ApplicationParameterDAOImpl;
import com.onemaster.pharmaplus.model.ApplicationParameter;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ApplicationParameterService {

    private final ApplicationParameterDAOImpl parameterDAO;

    // Cache thread-safe pour éviter les appels fréquents à la BDD
    private volatile Map<String, String> cachedParameters;
    private volatile long lastCacheUpdate = 0;
    private static final long CACHE_DURATION = 30000; // 30 secondes

    // Lock pour la synchronisation du cache
    private final Object cacheLock = new Object();

    // Mode debug
    private boolean debugMode = false;

    public ApplicationParameterService() {
        this.parameterDAO = new ApplicationParameterDAOImpl();
        this.debugMode = getBooleanValue("debug_mode", false);
        log("ApplicationParameterService initialisé");
    }

    // ============ MÉTHODES CRUD ============

    /**
     * Sauvegarde ou met à jour un paramètre
     */
    public void saveParameter(ApplicationParameter parameter) {
        if (parameter.getParameterKey() == null || parameter.getParameterKey().trim().isEmpty()) {
            throw new IllegalArgumentException("La clé du paramètre ne peut pas être vide");
        }

        log("Sauvegarde du paramètre: " + parameter.getParameterKey());

        try {
            if (parameterDAO.existsByKey(parameter.getParameterKey())) {
                parameterDAO.update(parameter);
                log("Paramètre mis à jour: " + parameter.getParameterKey());
            } else {
                parameterDAO.insert(parameter);
                log("Paramètre créé: " + parameter.getParameterKey());
            }
            invalidateCache();
        } catch (Exception e) {
            logError("Erreur lors de la sauvegarde du paramètre " + parameter.getParameterKey(), e);
            throw e;
        }
    }

    /**
     * Supprime un paramètre
     */
    public void deleteParameter(String parameterKey) {
        if (parameterKey == null || parameterKey.trim().isEmpty()) {
            throw new IllegalArgumentException("La clé du paramètre ne peut pas être vide");
        }

        log("Suppression du paramètre: " + parameterKey);
        parameterDAO.delete(parameterKey);
        invalidateCache();
    }

    /**
     * Récupère un paramètre par sa clé
     */
    public ApplicationParameter getParameter(String parameterKey) {
        log("Récupération du paramètre: " + parameterKey);
        return parameterDAO.findByKey(parameterKey);
    }

    /**
     * Alias pour getParameter - utilisé par le Servlet
     */
    public ApplicationParameter getParameterByKey(String parameterKey) {
        return getParameter(parameterKey);
    }

    /**
     * Récupère tous les paramètres
     */
    public List<ApplicationParameter> getAllParameters() {
        log("Récupération de tous les paramètres");
        try {
            List<ApplicationParameter> params = parameterDAO.findAll();
            log("Nombre de paramètres trouvés: " + params.size());
            return params;
        } catch (Exception e) {
            logError("Erreur lors de la récupération des paramètres", e);
            throw e;
        }
    }

    /**
     * Récupère les paramètres d'une catégorie
     */
    public List<ApplicationParameter> getParametersByCategory(String category) {
        if (category == null || category.trim().isEmpty()) {
            throw new IllegalArgumentException("La catégorie ne peut pas être vide");
        }

        log("Récupération des paramètres pour la catégorie: " + category);
        return parameterDAO.findByCategory(category);
    }

    /**
     * Vérifie si un paramètre existe
     */
    public boolean parameterExists(String parameterKey) {
        return parameterDAO.existsByKey(parameterKey);
    }

    // ============ MÉTHODES AVEC CACHE ============

    /**
     * Récupère une valeur avec valeur par défaut
     */
    public String getValue(String parameterKey, String defaultValue) {
        refreshCacheIfNeeded();
        String value = cachedParameters.getOrDefault(parameterKey, defaultValue);
        logDebug("getValue(" + parameterKey + ") = " + value);
        return value;
    }

    /**
     * Récupère une valeur entière
     */
    public Integer getIntValue(String parameterKey, Integer defaultValue) {
        String value = getValue(parameterKey, null);
        if (value != null) {
            try {
                return Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                logError("Erreur de conversion en Integer pour " + parameterKey + ": " + value, e);
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Récupère une valeur booléenne
     */
    public Boolean getBooleanValue(String parameterKey, Boolean defaultValue) {
        String value = getValue(parameterKey, null);
        if (value != null) {
            String trimmed = value.trim().toLowerCase();
            return "true".equals(trimmed) || "1".equals(trimmed) || "yes".equals(trimmed) || "on".equals(trimmed);
        }
        return defaultValue;
    }

    /**
     * Récupère une valeur décimale
     */
    public Double getDoubleValue(String parameterKey, Double defaultValue) {
        String value = getValue(parameterKey, null);
        if (value != null) {
            try {
                return Double.parseDouble(value.trim());
            } catch (NumberFormatException e) {
                logError("Erreur de conversion en Double pour " + parameterKey + ": " + value, e);
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Met à jour la valeur d'un paramètre existant
     */
    public void updateValue(String parameterKey, String newValue) {
        ApplicationParameter param = getParameter(parameterKey);
        if (param != null) {
            log("Mise à jour de " + parameterKey + " de '" + param.getParameterValue() + "' à '" + newValue + "'");
            param.setParameterValue(newValue);
            saveParameter(param);
        } else {
            throw new IllegalArgumentException("Paramètre non trouvé: " + parameterKey);
        }
    }

    // ============ GETTERS POUR PARAMÈTRES COURANTS (COMPATIBLES AVEC VOTRE SQL) ============

    // GENERAL - Compatible avec les clés de votre script SQL
    public String getApplicationName() {
        return getValue("app.name", "PharmaPlus");
    }

    public String getApplicationVersion() {
        return getValue("app.version", "1.0.0");
    }

    public String getPharmacyName() {
        return getValue("company.name", "OneMaster Pharma");
    }

    public String getPharmacyAddress() {
        return getValue("company.address", "");
    }

    public String getPharmacyPhone() {
        return getValue("company.phone", "");
    }

    public String getPharmacyEmail() {
        return getValue("company.email", "");
    }

    // UI - Compatible avec les clés de votre script SQL
    public String getTheme() {
        return getValue("ui.theme", "light");
    }

    public String getLanguage() {
        return getValue("ui.language", "fr");
    }

    public String getDateFormat() {
        return getValue("ui.date_format", "dd/MM/yyyy");
    }

    public String getTimeFormat() {
        return getValue("ui.time_format", "HH:mm");
    }

    public Integer getItemsPerPage() {
        return getIntValue("pagination.items_per_page", 20);
    }

    // FINANCIAL
    public String getDefaultCurrency() {
        return getValue("financial.default_currency", "MGA");
    }

    public Double getTaxRate() {
        return getDoubleValue("financial.vat_rate", 0.2);
    }

    public Boolean isDiscountEnabled() {
        return getBooleanValue("feature.auto_save", true); // Note: Vous pourriez vouloir créer un paramètre spécifique
    }

    // NOTIFICATION
    public Boolean isLowStockAlertEnabled() {
        return getBooleanValue("notification.stock_alert", true);
    }

    public Integer getLowStockThreshold() {
        return getIntValue("notification.expiry_alert_days", 10);
    }

    public Integer getExpiryAlertDays() {
        return getIntValue("notification.expiry_alert_days", 30);
    }

    public Boolean isEmailNotificationEnabled() {
        return getBooleanValue("notification.email.enabled", false);
    }

    // SECURITY
    public Integer getSessionTimeout() {
        return getIntValue("security.session_timeout", 30); // minutes
    }

    public Integer getPasswordMinLength() {
        return getIntValue("security.password_min_length", 8);
    }

    public Integer getMaxLoginAttempts() {
        return getIntValue("security.login_attempts", 3);
    }

    // FEATURE
    public Boolean isAutoSaveEnabled() {
        return getBooleanValue("feature.auto_save", true);
    }

    public Boolean isExportEnabled() {
        return getBooleanValue("feature.export_enabled", true);
    }

    // BUSINESS
    public String getWorkingHoursStart() {
        return getValue("business.working_hours_start", "08:00");
    }

    public String getWorkingHoursEnd() {
        return getValue("business.working_hours_end", "18:00");
    }

    public String getDefaultPaymentMethod() {
        return getValue("business.default_payment_method", "CASH");
    }

    // ============ GESTION DU CACHE ============

    /**
     * Rafraîchit le cache si nécessaire (thread-safe)
     */
    private void refreshCacheIfNeeded() {
        long currentTime = System.currentTimeMillis();

        // Double-checked locking pour la performance
        if (cachedParameters == null || (currentTime - lastCacheUpdate) > CACHE_DURATION) {
            synchronized (cacheLock) {
                // Vérifier à nouveau après avoir obtenu le lock
                if (cachedParameters == null || (currentTime - lastCacheUpdate) > CACHE_DURATION) {
                    log("Rafraîchissement du cache");
                    try {
                        Map<String, String> freshData = parameterDAO.getAllAsMap();
                        cachedParameters = new ConcurrentHashMap<>(freshData);
                        lastCacheUpdate = currentTime;
                        log("Cache rafraîchi avec " + freshData.size() + " entrées");
                    } catch (Exception e) {
                        logError("Erreur lors du rafraîchissement du cache", e);
                        // En cas d'erreur, utilisez un cache vide
                        cachedParameters = new ConcurrentHashMap<>();
                    }
                }
            }
        }
    }

    /**
     * Invalide le cache (force le rechargement)
     */
    private void invalidateCache() {
        synchronized (cacheLock) {
            log("Invalidation du cache");
            cachedParameters = null;
            lastCacheUpdate = 0;
        }
    }

    /**
     * Force le rechargement du cache
     */
    public void reloadCache() {
        invalidateCache();
        refreshCacheIfNeeded();
    }

    // ============ INITIALISATION DES PARAMÈTRES PAR DÉFAUT ============

    /**
     * Initialise tous les paramètres par défaut
     */
    public void initializeDefaultParameters() {
        log("Initialisation des paramètres par défaut");

        try {
            initializeGeneralParameters();
            initializeUIParameters();
            initializeFinancialParameters();
            initializeNotificationParameters();
            initializeSecurityParameters();
            initializeFeatureParameters();
            initializeBusinessParameters();
            initializeAdvancedParameters();

            invalidateCache();
            log("Paramètres par défaut initialisés avec succès");
        } catch (Exception e) {
            logError("Erreur lors de l'initialisation des paramètres par défaut", e);
            throw e;
        }
    }

    /**
     * Paramètres généraux de l'application
     */
    private void initializeGeneralParameters() {
        saveDefaultParameter("app.name", "PharmaPlus", "STRING", "GENERAL",
                "Nom de l'application");
        saveDefaultParameter("app.version", "1.0.0", "STRING", "GENERAL",
                "Version de l'application");
        saveDefaultParameter("company.name", "OneMaster Pharma", "STRING", "GENERAL",
                "Nom de la pharmacie");
        saveDefaultParameter("company.address", "", "STRING", "GENERAL",
                "Adresse complète de la pharmacie");
        saveDefaultParameter("company.phone", "", "STRING", "GENERAL",
                "Numéro de téléphone principal");
        saveDefaultParameter("company.email", "", "STRING", "GENERAL",
                "Adresse email de contact");
    }

    /**
     * Paramètres d'interface utilisateur
     */
    private void initializeUIParameters() {
        saveDefaultParameter("pagination.items_per_page", "20", "INTEGER", "UI",
                "Nombre d'éléments par page");
        saveDefaultParameter("ui.date_format", "dd/MM/yyyy", "STRING", "UI",
                "Format d'affichage des dates");
        saveDefaultParameter("ui.time_format", "HH:mm", "STRING", "UI",
                "Format d'affichage de l'heure");
        saveDefaultParameter("ui.theme", "light", "STRING", "UI",
                "Thème de l'interface (light/dark)");
        saveDefaultParameter("ui.language", "fr", "STRING", "UI",
                "Langue de l'interface");
    }

    /**
     * Paramètres financiers
     */
    private void initializeFinancialParameters() {
        saveDefaultParameter("financial.default_currency", "MGA", "STRING", "FINANCIAL",
                "Devise par défaut");
        saveDefaultParameter("financial.vat_rate", "0.2", "DECIMAL", "FINANCIAL",
                "Taux de TVA par défaut");
    }

    /**
     * Paramètres de notifications
     */
    private void initializeNotificationParameters() {
        saveDefaultParameter("notification.stock_alert", "true", "BOOLEAN", "NOTIFICATION",
                "Activer les alertes de stock bas");
        saveDefaultParameter("notification.expiry_alert_days", "30", "INTEGER", "NOTIFICATION",
                "Jours avant expiration pour alerter");
        saveDefaultParameter("notification.email.enabled", "false", "BOOLEAN", "NOTIFICATION",
                "Activer les notifications par email");
    }

    /**
     * Paramètres de sécurité
     */
    private void initializeSecurityParameters() {
        saveDefaultParameter("security.session_timeout", "30", "INTEGER", "SECURITY",
                "Durée d'inactivité avant déconnexion (minutes)");
        saveDefaultParameter("security.password_min_length", "8", "INTEGER", "SECURITY",
                "Longueur minimale du mot de passe");
        saveDefaultParameter("security.login_attempts", "3", "INTEGER", "SECURITY",
                "Nombre maximum de tentatives de connexion");
    }

    /**
     * Paramètres de fonctionnalités
     */
    private void initializeFeatureParameters() {
        saveDefaultParameter("feature.auto_save", "true", "BOOLEAN", "FEATURE",
                "Sauvegarde automatique des formulaires");
        saveDefaultParameter("feature.export_enabled", "true", "BOOLEAN", "FEATURE",
                "Activer l'exportation des données");
    }

    /**
     * Paramètres métiers
     */
    private void initializeBusinessParameters() {
        saveDefaultParameter("business.working_hours_start", "08:00", "STRING", "BUSINESS",
                "Heure d'ouverture");
        saveDefaultParameter("business.working_hours_end", "18:00", "STRING", "BUSINESS",
                "Heure de fermeture");
        saveDefaultParameter("business.default_payment_method", "CASH", "STRING", "BUSINESS",
                "Mode de paiement par défaut");
    }

    /**
     * Paramètres avancés
     */
    private void initializeAdvancedParameters() {
        saveDefaultParameter("debug_mode", "false", "BOOLEAN", "ADVANCED",
                "Mode debug (plus de logs)");
        saveDefaultParameter("log_retention_days", "30", "INTEGER", "ADVANCED",
                "Durée de conservation des logs (jours)");
    }

    /**
     * Sauvegarde un paramètre par défaut s'il n'existe pas déjà
     */
    private void saveDefaultParameter(String key, String value, String type,
                                      String category, String description) {
        if (!parameterDAO.existsByKey(key)) {
            ApplicationParameter param = new ApplicationParameter();
            param.setParameterKey(key);
            param.setParameterValue(value);
            param.setParameterType(type);
            param.setCategory(category);
            param.setDescription(description);
            parameterDAO.insert(param);
            log("Paramètre par défaut créé: " + key);
        }
    }

    // ============ MÉTHODES UTILITAIRES ============

    /**
     * Exporte tous les paramètres sous forme de Map
     */
    public Map<String, String> exportAllParameters() {
        log("Export de tous les paramètres");
        return parameterDAO.getAllAsMap();
    }

    /**
     * Importe plusieurs paramètres depuis une Map
     */
    public void importParameters(Map<String, String> parameters) {
        log("Import de " + parameters.size() + " paramètres");

        int imported = 0;
        int failed = 0;

        for (Map.Entry<String, String> entry : parameters.entrySet()) {
            try {
                ApplicationParameter param = getParameter(entry.getKey());
                if (param != null) {
                    param.setParameterValue(entry.getValue());
                    saveParameter(param);
                    imported++;
                } else {
                    log("Paramètre non trouvé pour import: " + entry.getKey());
                    failed++;
                }
            } catch (Exception e) {
                logError("Erreur lors de l'import du paramètre " + entry.getKey(), e);
                failed++;
            }
        }

        invalidateCache();
        log("Import terminé: " + imported + " succès, " + failed + " échecs");
    }

    /**
     * Réinitialise les paramètres d'une catégorie
     */
    public void resetCategory(String category) {
        log("Réinitialisation de la catégorie: " + category);

        List<ApplicationParameter> params = getParametersByCategory(category);
        log("Suppression de " + params.size() + " paramètres existants");

        for (ApplicationParameter param : params) {
            parameterDAO.delete(param.getParameterKey());
        }

        // Réinitialiser selon la catégorie
        switch (category.toUpperCase()) {
            case "GENERAL":
                initializeGeneralParameters();
                break;
            case "UI":
                initializeUIParameters();
                break;
            case "FINANCIAL":
                initializeFinancialParameters();
                break;
            case "NOTIFICATION":
                initializeNotificationParameters();
                break;
            case "SECURITY":
                initializeSecurityParameters();
                break;
            case "FEATURE":
                initializeFeatureParameters();
                break;
            case "BUSINESS":
                initializeBusinessParameters();
                break;
            case "ADVANCED":
                initializeAdvancedParameters();
                break;
            default:
                log("Catégorie inconnue pour réinitialisation: " + category);
        }

        invalidateCache();
        log("Catégorie " + category + " réinitialisée");
    }

    /**
     * Obtient les statistiques sur les paramètres
     */
    public Map<String, Object> getParameterStats() {
        log("Récupération des statistiques des paramètres");

        List<ApplicationParameter> allParams = getAllParameters();
        Map<String, Object> stats = new ConcurrentHashMap<>();

        stats.put("total", allParams.size());
        stats.put("byCategory", allParams.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        ApplicationParameter::getCategory,
                        java.util.stream.Collectors.counting()
                )));
        stats.put("byType", allParams.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        ApplicationParameter::getParameterType,
                        java.util.stream.Collectors.counting()
                )));

        log("Statistiques générées: " + allParams.size() + " paramètres");
        return stats;
    }

    /**
     * Teste la connexion à la base de données
     */
    public boolean testDatabaseConnection() {
        log("Test de la connexion à la base de données");
        try {
            List<ApplicationParameter> params = getAllParameters();
            boolean success = params != null;
            log("Test de connexion: " + (success ? "RÉUSSI" : "ÉCHOUÉ"));
            return success;
        } catch (Exception e) {
            logError("Échec du test de connexion", e);
            return false;
        }
    }

    /**
     * Récupère tous les paramètres groupés par catégorie
     */
    public Map<String, List<ApplicationParameter>> getParametersByCategoryGrouped() {
        List<ApplicationParameter> allParams = getAllParameters();
        return allParams.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        ApplicationParameter::getCategory
                ));
    }

    /**
     * Récupère toutes les catégories uniques
     */
    public List<String> getUniqueCategories() {
        List<ApplicationParameter> allParams = getAllParameters();
        return allParams.stream()
                .map(ApplicationParameter::getCategory)
                .distinct()
                .sorted()
                .collect(java.util.stream.Collectors.toList());
    }

    // ============ LOGGING ============

    private void log(String message) {
        System.out.println("[ApplicationParameterService] " + message);
    }

    private void logDebug(String message) {
        if (debugMode) {
            System.out.println("[ApplicationParameterService DEBUG] " + message);
        }
    }

    private void logError(String message, Exception e) {
        System.err.println("[ApplicationParameterService ERROR] " + message);
        if (e != null) {
            e.printStackTrace();
        }
    }
}