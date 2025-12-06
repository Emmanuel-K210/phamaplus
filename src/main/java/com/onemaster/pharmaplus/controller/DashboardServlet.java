package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.utils.SalesSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard", "/"})
public class DashboardServlet extends BaseServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        logInfo("Chargement du dashboard");
        
        try {
            // Vérifier la disponibilité des services
            if (!areServicesAvailable()) {
                throw new ServletException("Services non disponibles");
            }
            
            // 1. Statistiques produits
            int totalProducts = productService.getTotalProducts();
            int lowStockProducts = productService.getLowStockProducts().size();
            List<?> expiredProducts = inventoryService.getExpiredProducts();
            List<?> expiringSoon = inventoryService.getExpiringSoon(30);
            
            // 2. Statistiques ventes
            SalesSummary todaySummary = saleService.getTodaySummary();
            Double monthlyRevenue = saleService.getMonthlyRevenue(
                LocalDate.now().getYear(), 
                LocalDate.now().getMonthValue()
            );
            
            // 3. Clients actifs
            int activeCustomers = customerService.countAllCustomers();
            
            // 4. Valeur inventaire
            double inventoryValue = inventoryService.calculateTotalInventoryValue();
            
            // 5. Top produits et ventes récentes
            List<Object[]> topProducts = saleService.getTopProducts(5);
            List<Sale> recentSales = saleService.getRecentSales(10);
            
            // 6. Préparer les données pour la vue
            prepareDashboardData(request, totalProducts, lowStockProducts, 
                expiredProducts, expiringSoon, todaySummary, monthlyRevenue,
                activeCustomers, inventoryValue, topProducts, recentSales);
            
            // 7. Passer à la vue avec layout
            forwardToView(request, response, "/WEB-INF/views/dashboard.jsp");
            
        } catch (Exception e) {
            logError("Erreur dans DashboardServlet", e);
            handleError(request, response, "Impossible de charger le tableau de bord", e);
        }
    }
    
    /**
     * Préparation des données pour le dashboard
     */
    private void prepareDashboardData(HttpServletRequest request,
                                      int totalProducts,
                                      int lowStockProducts,
                                      List<?> expiredProducts,
                                      List<?> expiringSoon,
                                      SalesSummary todaySummary,
                                      Double monthlyRevenue,
                                      int activeCustomers,
                                      double inventoryValue,
                                      List<Object[]> topProducts,
                                      List<Sale> recentSales) {

        logInfo("Préparation des données...");
        logInfo("totalProducts: " + totalProducts);
        logInfo("lowStockProducts: " + lowStockProducts);
        logInfo("todaySummary: " + (todaySummary != null ? "non-null" : "null"));
        logInfo("inventoryValue: " + inventoryValue);

        try {
            request.setAttribute("pageTitle", "Tableau de Bord");
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("lowStockProducts", lowStockProducts);
            request.setAttribute("expiredProducts", expiredProducts.size());
            request.setAttribute("expiringSoon", expiringSoon.size());

            // IMPORTANT : Vérifiez que todaySummary n'est pas null
            if (todaySummary == null) {
                logWarning("todaySummary est null, création d'un objet vide");
                todaySummary = new SalesSummary();
            }
            request.setAttribute("todaySummary", todaySummary);

            request.setAttribute("monthlyRevenue", monthlyRevenue != null ? monthlyRevenue : 0.0);
            request.setAttribute("activeCustomers", activeCustomers);
            request.setAttribute("inventoryValue", inventoryValue);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("recentSales", recentSales);

        } catch (Exception e) {
            logError("Erreur dans prepareDashboardData", e);
            throw e; // Propager l'erreur
        }
    }
    
    /**
     * Forward vers la vue avec layout
     */
    private void forwardToView(HttpServletRequest request, 
                              HttpServletResponse response,
                              String viewPath) throws ServletException, IOException {
        
        request.setAttribute("contentPage", viewPath);
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
    
    /**
     * Gestion standardisée des erreurs
     */
    private void handleError(HttpServletRequest request,
                            HttpServletResponse response,
                            String message,
                            Exception e) throws ServletException, IOException {
        
        request.setAttribute("errorTitle", "Erreur Dashboard");
        request.setAttribute("errorMessage", message);
        request.setAttribute("errorDetails", e.getMessage());
        
        forwardToView(request, response, "/WEB-INF/views/errors/error.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}