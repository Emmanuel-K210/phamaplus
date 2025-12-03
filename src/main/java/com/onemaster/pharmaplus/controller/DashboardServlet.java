package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.service.*;
import com.onemaster.pharmaplus.utils.SalesSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard", "/"})
public class DashboardServlet extends HttpServlet {
    
    private ProductService productService;
    private InventoryService inventoryService;
    private SaleService saleService;
    
    @Override
    public void init() {
        productService = new ProductService();
        inventoryService = new InventoryService();
        saleService = new SaleService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Statistiques principales
        int totalProducts = productService.getTotalProducts();
        int lowStockProducts = productService.getLowStockProducts().size();
        int expiredProducts = inventoryService.getExpiredProducts().size();
        int expiringSoon = inventoryService.getExpiringSoon(30).size();
        
        // Statistiques de ventes
        SalesSummary todaySummary = saleService.getTodaySummary();
        Double monthlyRevenue = saleService.getMonthlyRevenue(
            LocalDate.now().getYear(), 
            LocalDate.now().getMonthValue()
        );
        
        // Top produits
        List<Object[]> topProducts = saleService.getTopProducts(5);
        
        // Ventes récentes
        List<Sale> recentSales = saleService.getRecentSales(10);
        
        // Préparer les données pour la vue
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("expiredProducts", expiredProducts);
        request.setAttribute("expiringSoon", expiringSoon);
        request.setAttribute("todaySummary", todaySummary);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("recentSales", recentSales);
        
        // Calculer la valeur totale de l'inventaire (simplifié)
        double inventoryValue = calculateInventoryValue();
        request.setAttribute("inventoryValue", inventoryValue);

        // Exemple pour dashboard
        request.setAttribute("pageTitle", "Dashboard");
        request.setAttribute("contentPage", "/WEB-INF/views/dashboard.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

    }
    
    private double calculateInventoryValue() {
        return 15000.0;
    }
}