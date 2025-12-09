package com.onemaster.pharmaplus.controller;

import com.google.gson.Gson;
import com.onemaster.pharmaplus.factory.ApplicationContext;
import com.onemaster.pharmaplus.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import java.util.logging.Logger;

/**
 * Servlet de base avec injection automatique des services
 */
public abstract class BaseServlet extends HttpServlet {
    
    protected static final Logger logger = Logger.getLogger(BaseServlet.class.getName());
    
    // Services protégés pour l'accès par les sous-classes
    protected ProductService productService;
    protected InventoryService inventoryService;
    protected SaleService saleService;
    protected CustomerService customerService;
    protected SupplierService supplierService;


    @Override
    public void init() throws ServletException {
        super.init();
        
        try {
            // Injection via ApplicationContext
            injectServices();
            
            // Initialisation spécifique
            initialize();
            
            logger.fine(getClass().getSimpleName() + " initialisé avec succès");
            
        } catch (Exception e) {
            logger.severe("Erreur d'initialisation du servlet " + getClass().getSimpleName() + ": " + e.getMessage());
            throw new ServletException("Impossible d'initialiser le servlet", e);
        }
    }
    
    /**
     * Injection des services
     */
    private void injectServices() {
        productService = ApplicationContext.getProductService();
        inventoryService = ApplicationContext.getInventoryService();
        saleService = ApplicationContext.getSaleService();
        customerService = ApplicationContext.getCustomerService();
        supplierService = ApplicationContext.getSupplierService();
    }
    
    /**
     * Méthode d'initialisation spécifique (à surcharger si nécessaire)
     */
    protected void initialize() throws ServletException {
        // À surcharger par les sous-classes
    }
    
    /**
     * Vérifie si les services sont disponibles
     */
    protected boolean areServicesAvailable() {
        return productService != null &&
               inventoryService != null &&
               saleService != null &&
               customerService != null;
    }
    
    /**
     * Journalisation standardisée
     */
    protected void logInfo(String message) {
        logger.info("[" + getClass().getSimpleName() + "] " + message);
    }
    
    protected void logWarning(String message) {
        logger.warning("[" + getClass().getSimpleName() + "] " + message);
    }
    
    protected void logError(String message, Exception e) {
        logger.severe("[" + getClass().getSimpleName() + "] " + message + " - " + e.getMessage());
    }
}