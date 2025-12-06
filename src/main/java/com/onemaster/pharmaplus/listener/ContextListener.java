package com.onemaster.pharmaplus.listener;

import com.onemaster.pharmaplus.factory.ApplicationContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class ContextListener implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(ContextListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("=== Démarrage de l'application PharmaPlus ===");
        
        try {
            // Initialiser le contexte d'application
            ApplicationContext.initialize(sce.getServletContext());
            
            // Configuration supplémentaire
            configureApplication(sce);
            
            logger.info("=== Application PharmaPlus initialisée avec succès ===");
            
        } catch (Exception e) {
            logger.severe("=== ÉCHEC de l'initialisation de l'application ===");
            logger.severe("Erreur: " + e.getMessage());
            throw new RuntimeException("Impossible de démarrer l'application", e);
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("=== Arrêt de l'application PharmaPlus ===");
        
        try {
            // Nettoyage propre
            ApplicationContext.destroy();
            logger.info("=== Application arrêtée proprement ===");
            
        } catch (Exception e) {
            logger.warning("Erreur lors de l'arrêt de l'application: " + e.getMessage());
        }
    }
    
    private void configureApplication(ServletContextEvent sce) {
        // Configuration de l'application
        sce.getServletContext().setAttribute("appName", "PharmaPlus");
        sce.getServletContext().setAttribute("appVersion", "1.0.0");
        sce.getServletContext().setAttribute("currency", "F CFA");
        
        // Configuration pour JSP
        sce.getServletContext().setAttribute("defaultDateFormat", "dd/MM/yyyy");
        sce.getServletContext().setAttribute("defaultCurrencyFormat", "#,##0 F CFA");
        
        logger.info("Configuration appliquée: Devise=" + sce.getServletContext().getAttribute("currency"));
    }
}