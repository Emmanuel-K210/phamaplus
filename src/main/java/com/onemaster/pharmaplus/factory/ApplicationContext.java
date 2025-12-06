package com.onemaster.pharmaplus.factory;

import com.onemaster.pharmaplus.service.*;
import jakarta.servlet.ServletContext;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Gestionnaire centralisé du contexte d'application
 */
public class ApplicationContext {
    private static final Logger logger = Logger.getLogger(ApplicationContext.class.getName());
    
    private static final Map<String, Object> services = new HashMap<>();
    private static ServletContext servletContext;
    
    private ApplicationContext() {}
    
    /**
     * Initialise le contexte d'application
     */
    public static void initialize(ServletContext context) {
        servletContext = context;
        logger.info("Initialisation du contexte d'application...");
        
        // Initialiser tous les services
        initializeServices();
        
        // Stocker les services dans le contexte Servlet
        storeServicesInContext();
        
        logger.info("Contexte d'application initialisé avec succès");
    }
    
    private static void initializeServices() {
        try {
            // Initialisation séquentielle avec gestion d'erreur
            ProductService productService = ServiceFactory.getProductService();
            services.put("productService", productService);
            
            InventoryService inventoryService = ServiceFactory.getInventoryService();
            services.put("inventoryService", inventoryService);
            
            SaleService saleService = ServiceFactory.getSaleService();
            services.put("saleService", saleService);
            
            CustomerService customerService = ServiceFactory.getCustomerService();
            services.put("customerService", customerService);
            
            SupplierService supplierService = ServiceFactory.getSupplierService();
            services.put("supplierService", supplierService);
            
        } catch (Exception e) {
            logger.severe("Échec de l'initialisation des services: " + e.getMessage());
            throw new ServiceInitializationException("Échec de l'initialisation de l'application", e);
        }
    }
    
    private static void storeServicesInContext() {
        if (servletContext != null) {
            services.forEach((key, service) -> {
                servletContext.setAttribute(key, service);
                logger.fine("Service '" + key + "' stocké dans ServletContext");
            });
        }
    }
    
    /**
     * Obtient un service par son nom
     */
    @SuppressWarnings("unchecked")
    public static <T> T getService(String serviceName) {
        Object service = services.get(serviceName);
        if (service == null) {
            throw new ServiceInitializationException("Service non trouvé: " + serviceName);
        }
        return (T) service;
    }
    
    /**
     * Obtient le ProductService
     */
    public static ProductService getProductService() {
        return getService("productService");
    }
    
    /**
     * Obtient l'InventoryService
     */
    public static InventoryService getInventoryService() {
        return getService("inventoryService");
    }
    
    /**
     * Obtient le SaleService
     */
    public static SaleService getSaleService() {
        return getService("saleService");
    }
    
    /**
     * Obtient le CustomerService
     */
    public static CustomerService getCustomerService() {
        return getService("customerService");
    }

    /**
     * Obtient le SupplierService
     */
    public static  SupplierService getSupplierService() {return getService("supplierService");}

    /**
     * Nettoyage du contexte (pour arrêt propre)
     */
    public static void destroy() {
        services.clear();
        ServiceFactory.resetAll();
        logger.info("Contexte d'application nettoyé");
    }
}