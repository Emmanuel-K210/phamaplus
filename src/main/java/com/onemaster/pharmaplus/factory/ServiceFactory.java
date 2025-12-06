package com.onemaster.pharmaplus.factory;

import com.onemaster.pharmaplus.service.*;
import java.util.logging.Logger;

public class ServiceFactory {
    private static final Logger logger = Logger.getLogger(ServiceFactory.class.getName());
    
    // Instances uniques (Singleton pattern)
    private static ProductService productService;
    private static InventoryService inventoryService;
    private static SaleService saleService;
    private static CustomerService customerService;
    private static SupplierService supplierService;
    
    // Empêche l'instanciation
    private ServiceFactory() {}
    
    /**
     * Obtient l'instance de ProductService
     */
    public static synchronized ProductService getProductService() {
        if (productService == null) {
            try {
                productService = new ProductService();
                logger.info("ProductService initialisé");
            } catch (Exception e) {
                logger.severe("Erreur d'initialisation de ProductService: " + e.getMessage());
                throw new ServiceInitializationException("Impossible d'initialiser ProductService", e);
            }
        }
        return productService;
    }
    
    /**
     * Obtient l'instance de InventoryService
     */
    public static synchronized InventoryService getInventoryService() {
        if (inventoryService == null) {
            try {
                inventoryService = new InventoryService();
                logger.info("InventoryService initialisé");
            } catch (Exception e) {
                logger.severe("Erreur d'initialisation de InventoryService: " + e.getMessage());
                throw new ServiceInitializationException("Impossible d'initialiser InventoryService", e);
            }
        }
        return inventoryService;
    }
    
    /**
     * Obtient l'instance de SaleService
     */
    public static synchronized SaleService getSaleService() {
        if (saleService == null) {
            try {
                saleService = new SaleService();
                logger.info("SaleService initialisé");
            } catch (Exception e) {
                logger.severe("Erreur d'initialisation de SaleService: " + e.getMessage());
                throw new ServiceInitializationException("Impossible d'initialiser SaleService", e);
            }
        }
        return saleService;
    }
    
    /**
     * Obtient l'instance de CustomerService
     */
    public static synchronized CustomerService getCustomerService() {
        if (customerService == null) {
            try {
                customerService = new CustomerService();
                logger.info("CustomerService initialisé");
            } catch (Exception e) {
                logger.severe("Erreur d'initialisation de CustomerService: " + e.getMessage());
                throw new ServiceInitializationException("Impossible d'initialiser CustomerService", e);
            }
        }
        return customerService;
    }
    
    /**
     * Obtient l'instance de SupplierService
     */
    public static synchronized SupplierService getSupplierService() {
        if (supplierService == null) {
            try {
                supplierService = new SupplierService();
                logger.info("SupplierService initialisé");
            } catch (Exception e) {
                logger.severe("Erreur d'initialisation de SupplierService: " + e.getMessage());
                throw new ServiceInitializationException("Impossible d'initialiser SupplierService", e);
            }
        }
        return supplierService;
    }
    
    /**
     * Réinitialise toutes les instances (utile pour les tests)
     */
    public static synchronized void resetAll() {
        productService = null;
        inventoryService = null;
        saleService = null;
        customerService = null;
        supplierService = null;
        logger.info("Tous les services ont été réinitialisés");
    }
    
    /**
     * Vérifie si tous les services sont initialisés
     */
    public static boolean areAllServicesInitialized() {
        return productService != null &&
               inventoryService != null &&
               saleService != null &&
               customerService != null;
    }
}