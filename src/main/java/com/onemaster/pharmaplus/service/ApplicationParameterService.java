package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.ApplicationParameterDAOImpl;
import com.onemaster.pharmaplus.model.ApplicationParameter;

import java.util.List;
import java.util.Map;

public class ApplicationParameterService {
    
    private final ApplicationParameterDAOImpl parameterDAO;
    
    // Cache pour éviter les appels fréquents à la BDD
    private Map<String, String> cachedParameters;
    private long lastCacheUpdate = 0;
    private static final long CACHE_DURATION = 30000; // 30 secondes
    
    public ApplicationParameterService() {
        this.parameterDAO = new ApplicationParameterDAOImpl();
    }
    
    // Méthodes CRUD
    public void saveParameter(ApplicationParameter parameter) {
        if (parameterDAO.existsByKey(parameter.getParameterKey())) {
            parameterDAO.update(parameter);
        } else {
            parameterDAO.insert(parameter);
        }
        invalidateCache();
    }
    
    public void deleteParameter(String parameterKey) {
        parameterDAO.delete(parameterKey);
        invalidateCache();
    }
    
    public ApplicationParameter getParameter(String parameterKey) {
        return parameterDAO.findByKey(parameterKey);
    }
    
    public List<ApplicationParameter> getAllParameters() {
        return parameterDAO.findAll();
    }
    
    public List<ApplicationParameter> getParametersByCategory(String category) {
        return parameterDAO.findByCategory(category);
    }
    
    // Méthodes pour récupérer des valeurs avec cache
    public String getValue(String parameterKey, String defaultValue) {
        refreshCacheIfNeeded();
        return cachedParameters.getOrDefault(parameterKey, defaultValue);
    }
    
    public Integer getIntValue(String parameterKey, Integer defaultValue) {
        String value = getValue(parameterKey, null);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    public Boolean getBooleanValue(String parameterKey, Boolean defaultValue) {
        String value = getValue(parameterKey, null);
        return value != null ? Boolean.parseBoolean(value) : defaultValue;
    }
    
    public Double getDoubleValue(String parameterKey, Double defaultValue) {
        String value = getValue(parameterKey, null);
        if (value != null) {
            try {
                return Double.parseDouble(value);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
    
    // Gestion des paramètres courants
    public String getApplicationName() {
        return getValue("app.name", "PharmaPlus");
    }
    
    public String getApplicationVersion() {
        return getValue("app.version", "1.0.0");
    }
    
    public String getCompanyName() {
        return getValue("company.name", "OneMaster Pharma");
    }
    
    public String getCompanyAddress() {
        return getValue("company.address", "");
    }
    
    public String getCompanyPhone() {
        return getValue("company.phone", "");
    }
    
    public String getCompanyEmail() {
        return getValue("company.email", "");
    }
    
    public Integer getItemsPerPage() {
        return getIntValue("pagination.items_per_page", 20);
    }
    
    public Boolean isAutoSaveEnabled() {
        return getBooleanValue("feature.auto_save", true);
    }
    
    public Boolean isEmailNotificationEnabled() {
        return getBooleanValue("notification.email.enabled", false);
    }
    
    public Double getVATRate() {
        return getDoubleValue("financial.vat_rate", 0.2); // 20% par défaut
    }
    
    public String getDefaultCurrency() {
        return getValue("financial.default_currency", "MGA");
    }
    
    public Integer getSessionTimeout() {
        return getIntValue("security.session_timeout", 30); // minutes
    }
    
    public Integer getPasswordMinLength() {
        return getIntValue("security.password_min_length", 8);
    }
    
    public String getDateFormat() {
        return getValue("ui.date_format", "dd/MM/yyyy");
    }
    
    public String getTimeFormat() {
        return getValue("ui.time_format", "HH:mm");
    }
    
    // Méthodes de cache
    private void refreshCacheIfNeeded() {
        long currentTime = System.currentTimeMillis();
        if (cachedParameters == null || (currentTime - lastCacheUpdate) > CACHE_DURATION) {
            cachedParameters = parameterDAO.getAllAsMap();
            lastCacheUpdate = currentTime;
        }
    }
    
    private void invalidateCache() {
        cachedParameters = null;
        lastCacheUpdate = 0;
    }
    
    // Initialisation des paramètres par défaut
    public void initializeDefaultParameters() {
        // Paramètres généraux
        saveDefaultParameter("app.name", "PharmaPlus", "STRING", "GENERAL", "Nom de l'application");
        saveDefaultParameter("app.version", "1.0.0", "STRING", "GENERAL", "Version de l'application");
        saveDefaultParameter("company.name", "OneMaster Pharma", "STRING", "GENERAL", "Nom de la pharmacie");
        saveDefaultParameter("company.address", "", "STRING", "GENERAL", "Adresse de la pharmacie");
        saveDefaultParameter("company.phone", "", "STRING", "GENERAL", "Téléphone de la pharmacie");
        saveDefaultParameter("company.email", "", "STRING", "GENERAL", "Email de la pharmacie");
        
        // Paramètres UI
        saveDefaultParameter("pagination.items_per_page", "20", "INTEGER", "UI", "Nombre d'éléments par page");
        saveDefaultParameter("ui.date_format", "dd/MM/yyyy", "STRING", "UI", "Format de date");
        saveDefaultParameter("ui.time_format", "HH:mm", "STRING", "UI", "Format d'heure");
        saveDefaultParameter("ui.theme", "light", "STRING", "UI", "Thème de l'interface");
        saveDefaultParameter("ui.language", "fr", "STRING", "UI", "Langue de l'interface");
        
        // Paramètres de sécurité
        saveDefaultParameter("security.session_timeout", "30", "INTEGER", "SECURITY", "Timeout session (minutes)");
        saveDefaultParameter("security.password_min_length", "8", "INTEGER", "SECURITY", "Longueur minimale mot de passe");
        saveDefaultParameter("security.login_attempts", "3", "INTEGER", "SECURITY", "Tentatives de connexion max");
        saveDefaultParameter("security.password_expiry_days", "90", "INTEGER", "SECURITY", "Expiration mot de passe (jours)");
        
        // Paramètres financiers
        saveDefaultParameter("financial.vat_rate", "0.2", "DECIMAL", "FINANCIAL", "Taux de TVA");
        saveDefaultParameter("financial.default_currency", "MGA", "STRING", "FINANCIAL", "Devise par défaut");
        saveDefaultParameter("financial.rounding_method", "HALF_UP", "STRING", "FINANCIAL", "Méthode d'arrondi");
        
        // Paramètres des fonctionnalités
        saveDefaultParameter("feature.auto_save", "true", "BOOLEAN", "FEATURE", "Sauvegarde automatique");
        saveDefaultParameter("feature.export_enabled", "true", "BOOLEAN", "FEATURE", "Exportation activée");
        saveDefaultParameter("feature.backup_enabled", "true", "BOOLEAN", "FEATURE", "Sauvegarde automatique");
        saveDefaultParameter("feature.notification_enabled", "true", "BOOLEAN", "FEATURE", "Notifications activées");
        
        // Paramètres de notification
        saveDefaultParameter("notification.email.enabled", "false", "BOOLEAN", "NOTIFICATION", "Notifications email activées");
        saveDefaultParameter("notification.sms.enabled", "false", "BOOLEAN", "NOTIFICATION", "Notifications SMS activées");
        saveDefaultParameter("notification.stock_alert", "true", "BOOLEAN", "NOTIFICATION", "Alerte stock bas");
        saveDefaultParameter("notification.expiry_alert_days", "30", "INTEGER", "NOTIFICATION", "Jours avant alerte expiration");
        
        // Paramètres métiers
        saveDefaultParameter("business.working_hours_start", "08:00", "STRING", "BUSINESS", "Heure d'ouverture");
        saveDefaultParameter("business.working_hours_end", "18:00", "STRING", "BUSINESS", "Heure de fermeture");
        saveDefaultParameter("business.default_payment_method", "CASH", "STRING", "BUSINESS", "Mode de paiement par défaut");
        saveDefaultParameter("business.auto_generate_invoice", "true", "BOOLEAN", "BUSINESS", "Génération automatique facture");
    }
    
    private void saveDefaultParameter(String key, String value, String type, String category, String description) {
        if (!parameterDAO.existsByKey(key)) {
            ApplicationParameter param = new ApplicationParameter();
            param.setParameterKey(key);
            param.setParameterValue(value);
            param.setParameterType(type);
            param.setCategory(category);
            param.setDescription(description);
            parameterDAO.insert(param);
        }
    }
}