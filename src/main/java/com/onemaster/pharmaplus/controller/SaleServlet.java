package com.onemaster.pharmaplus.controller;

import com.google.gson.Gson;
import com.onemaster.pharmaplus.dao.impl.SaleDAOImpl;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.*;
import com.onemaster.pharmaplus.service.*;
import com.onemaster.pharmaplus.utils.SalesSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "SaleServlet", urlPatterns = {
        "/sales",
        "/sales/new",
        "/sales/create",
        "/sales/view",
        "/sales/cancel",
        "/sales/report",
        "/sales/daily",
        "/sales/api/products",
        "/sales/api/customers",
})
public class SaleServlet extends HttpServlet {

    private SaleService saleService;
    private ProductService productService;
    private CustomerService customerService;
    private InventoryService inventoryService;
    private Gson gson;

    @Override
    public void init() {
        saleService = new SaleService();
        productService = new ProductService();
        customerService = new CustomerService();
        inventoryService = new InventoryService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/sales":
                listSales(request, response);
                break;
            case "/sales/new":
                showNewSaleForm(request, response);
                break;
            case "/sales/create":
                showNewSaleForm(request, response);
                break;
            case "/sales/view":
                viewSale(request, response);
                break;
            case "/sales/report":
                showSalesReport(request, response);
                break;
            case "/sales/daily":
                showDailySales(request, response);
                break;
            case "/sales/api/products":
                searchProductsAPI(request, response);
                break;
            case "/sales/api/customers":
                searchCustomersAPI(request, response);
                break;
            default:
                listSales(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        if ("/sales/create".equals(action)) {
            createSale(request, response);
        } else if ("/sales/cancel".equals(action)) {
            cancelSale(request, response);
        }
    }

    private void listSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Par défaut, afficher les ventes d'aujourd'hui
        LocalDate today = LocalDate.now();
        List<Sale> sales = saleService.getSalesByDate(today);

        request.setAttribute("sales", sales);
        request.setAttribute("date", today);
        request.setAttribute("totalSales", sales.size());

        // Récupérer le résumé du jour
        SalesSummary summary = saleService.getTodaySummary();
        request.setAttribute("todaySummary", summary);

        // Pour le dashboard - dernières ventes
        List<Sale> recentSales = sales.size() > 5 ? sales.subList(0, 5) : sales;
        request.setAttribute("recentSales", recentSales);

        request.setAttribute("pageTitle", "Liste des Ventes");
        request.setAttribute("contentPage", "/WEB-INF/views/sales/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showNewSaleForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Passer quelques produits populaires pour suggestions
        List<Product> allProducts = productService.getAllProducts();
        List<Product> popularProducts = allProducts.subList(0,
                Math.min(10, allProducts.size()));

        request.setAttribute("popularProducts", popularProducts);
        request.setAttribute("pageTitle", "Nouvelle Vente");
        request.setAttribute("contentPage", "/WEB-INF/views/sales/new.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void createSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Créer l'objet Sale
            Sale sale = new Sale();

            // Client (peut être null pour vente sans client enregistré)
            String customerIdStr = request.getParameter("customerId");
            if (customerIdStr != null && !customerIdStr.isEmpty()) {
                sale.setCustomerId(Integer.parseInt(customerIdStr));
            }

            // Méthode de paiement
            sale.setPaymentMethod(request.getParameter("paymentMethod"));
            sale.setServedBy(request.getParameter("servedBy") != null ?
                    request.getParameter("servedBy") : "System");

            // Récupérer les items du panier
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] prices = request.getParameterValues("price[]");

            if (productIds == null || productIds.length == 0) {
                throw new IllegalArgumentException("Le panier est vide");
            }

            List<SaleItem> items = new ArrayList<>();

            for (int i = 0; i < productIds.length; i++) {
                Integer productId = Integer.parseInt(productIds[i]);
                Integer quantity = Integer.parseInt(quantities[i]);
                Double price = Double.parseDouble(prices[i]);

                // Trouver le meilleur lot pour ce produit
                Inventory bestBatch = inventoryService.findBestBatchForProduct(productId, quantity);
                if (bestBatch == null) {
                    throw new IllegalArgumentException("Stock insuffisant pour le produit ID: " + productId);
                }

                SaleItem item = new SaleItem();
                item.setProductId(productId);
                item.setInventoryId(bestBatch.getInventoryId());
                item.setQuantity(quantity);
                item.setUnitPrice(price);
                item.setLineTotal(quantity * price);

                items.add(item);
            }

            // Créer la vente
            Integer saleId = saleService.createSale(sale, items);

            // Rediriger vers le reçu
            response.sendRedirect(request.getContextPath() + "/sales/view?id=" + saleId + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la création de la vente: " + e.getMessage());
            showNewSaleForm(request, response);
        }
    }

    private void viewSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer saleId = Integer.parseInt(request.getParameter("id"));
            Sale sale = saleService.getSaleWithItems(saleId);

            if (sale != null) {
                // Récupérer les items
                SaleDAO saleDAO = new SaleDAOImpl();
                List<SaleItem> items = saleDAO.findItemsBySaleId(saleId);

                request.setAttribute("sale", sale);
                request.setAttribute("items", items);
                request.setAttribute("pageTitle", "Reçu de Vente #" + saleId);
                request.setAttribute("contentPage", "/WEB-INF/views/sales/receipt.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/sales?error=Vente+non+trouvée");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sales?error=ID+invalide");
        }
    }

    private void showSalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate startDate = LocalDate.now().minusDays(30); // Par défaut 30 derniers jours
        LocalDate endDate = LocalDate.now();

        if (request.getParameter("startDate") != null) {
            startDate = LocalDate.parse(request.getParameter("startDate"));
        }
        if (request.getParameter("endDate") != null) {
            endDate = LocalDate.parse(request.getParameter("endDate"));
        }

        List<Sale> sales = saleService.getSalesByDateRange(startDate, endDate);
        Double totalRevenue = saleService.getTotalRevenue(startDate, endDate);
        Integer totalItems = saleService.getTotalItemsSold(startDate, endDate);

        // Top produits
        List<Object[]> topProducts = saleService.getTopProducts(10);

        // Préparer les données pour les graphiques
        // TODO: Implémenter la génération des données JSON pour les graphiques

        request.setAttribute("sales", sales);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("topProducts", topProducts);

        request.setAttribute("pageTitle", "Rapport des Ventes");
        request.setAttribute("contentPage", "/WEB-INF/views/sales/report.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showDailySales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate date = LocalDate.now();
        if (request.getParameter("date") != null) {
            date = LocalDate.parse(request.getParameter("date"));
        }

        List<Sale> sales = saleService.getSalesByDate(date);
        Double dailyRevenue = saleService.getDailyRevenue(date);

        request.setAttribute("sales", sales);
        request.setAttribute("date", date);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("transactionCount", sales.size());

        request.setAttribute("pageTitle", "Ventes du " + date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        request.setAttribute("contentPage", "/WEB-INF/views/sales/daily.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    // APIs pour auto-complétion (AJAX)
    private void searchProductsAPI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        List<Product> products = productService.searchProductsByName(query);

        // Retourner en JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<ProductDTO> productDTOs = new ArrayList<>();
        for (int i = 0; i < products.size() && i < 10; i++) {
            Product p = products.get(i);
            ProductDTO dto = new ProductDTO();
            dto.id = p.getProductId();
            dto.name = p.getProductName();
            dto.price = p.getSellingPrice();
            dto.stock = inventoryService.getAvailableStockForProduct(p.getProductId());
            dto.barcode = p.getBarcode();
            productDTOs.add(dto);
        }

        String json = gson.toJson(productDTOs);
        response.getWriter().write(json);
    }

    private void searchCustomersAPI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        List<Customer> customers = customerService.findCustomersForAutocomplete(query);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<CustomerDTO> customerDTOs = new ArrayList<>();
        for (int i = 0; i < customers.size() && i < 10; i++) {
            Customer c = customers.get(i);
            CustomerDTO dto = new CustomerDTO();
            dto.id = c.getCustomerId();
            dto.name = c.getFullName();
            dto.phone = c.getPhone();
            dto.email = c.getEmail() != null ? c.getEmail() : "";
            customerDTOs.add(dto);
        }

        String json = gson.toJson(customerDTOs);
        response.getWriter().write(json);
    }

    private void cancelSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer saleId = Integer.parseInt(request.getParameter("id"));
            boolean success = saleService.cancelSale(saleId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/sales?success=Vente+annulée+avec+succès");
            } else {
                response.sendRedirect(request.getContextPath() + "/sales?error=Échec+de+l'annulation");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sales?error=ID+invalide");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/sales?error=Erreur:+" + e.getMessage());
        }
    }

    // Classes DTO pour JSON
    private static class ProductDTO {
        Integer id;
        String name;
        Double price;
        Integer stock;
        String barcode;
    }

    private static class CustomerDTO {
        Integer id;
        String name;
        String phone;
        String email;
    }
}