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
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@WebServlet(name = "SaleServlet", urlPatterns = {
        "/sales",
        "/sales/new",
        "/sales/create",
        "/sales/view",
        "/sales/cancel",
        "/sales/complete",
        "/sales/report",
        "/sales/daily",
        "/sales/export",
        "/sales/api/products",
        "/sales/api/customers",
        "/sales/api/stats"
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
            case "/sales/export":
                exportSales(request, response);
                break;
            case "/sales/api/products":
                searchProductsAPI(request, response);
                break;
            case "/sales/api/customers":
                searchCustomersAPI(request, response);
                break;
            case "/sales/api/stats":
                getSalesStatsAPI(request, response);
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
        } else if ("/sales/complete".equals(action)) {
            completeSale(request, response);
        }
    }

    private void listSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Désactiver le cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            // Récupérer les paramètres de filtrage
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String dateParam = request.getParameter("date");

            // Pagination
            int page = 1;
            int pageSize = 20;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Date par défaut = aujourd'hui
            LocalDate date = LocalDate.now();
            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    date = LocalDate.parse(dateParam);
                } catch (Exception e) {
                    // Garder la date d'aujourd'hui
                }
            }

            // Récupérer les ventes filtrées
            List<Sale> sales = saleService.getSalesByDate(date);

            // Appliquer les filtres supplémentaires si nécessaire
            if (search != null && !search.isEmpty()) {
                sales = sales.stream()
                        .filter(sale -> {
                            // Filtrer par ID de vente ou nom de client
                            if (sale.getSaleId().toString().contains(search)) {
                                return true;
                            }
                            if (sale.getCustomerId() != null) {
                                Customer customer = customerService.getCustomerById(sale.getCustomerId());
                                if (customer != null && customer.getFullName().toLowerCase().contains(search.toLowerCase())) {
                                    return true;
                                }
                            }
                            return false;
                        })
                        .collect(Collectors.toList());
            }

            if (status != null && !status.isEmpty()) {
                sales = sales.stream()
                        .filter(sale -> status.equals(sale.getPaymentStatus()))
                        .collect(Collectors.toList());
            }

            // Calcul de la pagination
            int totalSales = sales.size();
            int totalPages = (int) Math.ceil((double) totalSales / pageSize);
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalSales);

            List<Sale> paginatedSales = totalSales > 0 ?
                    sales.subList(startIndex, endIndex) :
                    new ArrayList<>();

            // Convertir en DTO
            List<SaleDTO> saleDTOS = new ArrayList<>();
            for (Sale sale : paginatedSales) {
                Customer customer = null;
                if (sale.getCustomerId() != null) {
                    customer = customerService.getCustomerById(sale.getCustomerId());
                }
                saleDTOS.add(toSaleDTO(sale, customer));
            }

            // === CORRECTION : CALCUL EN ENTIERS POUR FCFA ===

            // 1. Ventes d'aujourd'hui (payées seulement)
            List<Sale> allSalesToday = saleService.getSalesByDate(LocalDate.now());

            double todayRevenue = 0;
            int todayTransactions = 0;

            for (Sale sale : allSalesToday) {
                if ("paid".equals(sale.getPaymentStatus())) {
                    double amount = sale.getTotalAmount();
                    todayRevenue += amount;
                    todayTransactions++;
                }
            }

            // 2. Ventes du mois (payées seulement)
            LocalDate firstDayOfMonth = LocalDate.now().withDayOfMonth(1);
            LocalDate lastDayOfMonth = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());
            List<Sale> monthSalesList = saleService.getSalesByDateRange(firstDayOfMonth, lastDayOfMonth);

            double monthRevenue = monthSalesList
                    .stream()
                    .mapToDouble(Sale::getTotalAmount)
                    .sum();

            // 3. Ticket moyen (entier arrondi)
            double avgTicket = todayTransactions > 0 ? todayRevenue / todayTransactions : 0;

            // === FORMATAGE FINAL ===

            request.setAttribute("totalTransactions", todayTransactions);
            request.setAttribute("todaySalesValue", todayRevenue);
            request.setAttribute("monthSalesValue", monthRevenue);
            request.setAttribute("avgTicketValue", avgTicket);

            // Pagination et filtres
            request.setAttribute("sales", saleDTOS);
            request.setAttribute("date", date);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageActive","sales");
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchParam", search != null ? search : "");
            request.setAttribute("statusParam", status != null ? status : "");
            request.setAttribute("dateParam", dateParam != null ? dateParam : "");

            request.setAttribute("pageTitle", "Liste des Ventes");
            request.setAttribute("contentPage", "/WEB-INF/views/sales/list.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement des ventes: " + e.getMessage());
            request.setAttribute("sales", new ArrayList<>());
            request.setAttribute("todaySales", "0 FCFA");
            request.setAttribute("monthSales", "0 FCFA");
            request.setAttribute("totalTransactions", 0);
            request.setAttribute("avgTicket", "0 FCFA");
            request.setAttribute("pageTitle", "Liste des Ventes");
            request.setAttribute("contentPage", "/WEB-INF/views/sales/list.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    /**
     * Convertit un Sale en SaleDTO avec gestion des montants en entiers
     */
    private SaleDTO toSaleDTO(Sale sale, Customer customer) {
        if (sale == null) {
            return SaleDTO.builder().build();
        }

        // Calculer le nombre total d'articles (quantité totale, pas nombre de lignes)
        int totalItems = calculateTotalItems(sale.getSaleId());

        return SaleDTO.builder()
                .saleId(sale.getSaleId())
                .customerName(customer != null ? customer.getFullName() : "Client non enregistré")
                .customerPhone(customer != null ? customer.getPhone() : "")
                .totalItems(totalItems)
                .totalAmount(sale.getTotalAmount()) // Garder en Double pour compatibilité
                .discountAmount(sale.getDiscountAmount())
                .paymentMethod(sale.getPaymentMethod())
                .paymentStatus(sale.getPaymentStatus())
                .saleDate(convertToDate(sale.getSaleDate()))
                .build();
    }


    /**
     * Calcule le nombre total d'articles dans une vente (somme des quantités)
     */
    private int calculateTotalItems(Integer saleId) {
        if (saleId == null) return 0;

        try {
            SaleDAO saleDAO = new SaleDAOImpl();
            List<SaleItem> items = saleDAO.findItemsBySaleId(saleId);
            if (items != null && !items.isEmpty()) {
                // Somme des quantités de chaque item
                return items.stream()
                        .mapToInt(SaleItem::getQuantity)
                        .sum();
            }
        } catch (Exception e) {
            System.err.println("Erreur calcul total items pour vente #" + saleId + ": " + e.getMessage());
        }
        return 0;
    }

    /**
     * Convertit LocalDateTime en Date
     */
    private Date convertToDate(LocalDateTime localDateTime) {
        if (localDateTime == null) return new Date();
        return java.sql.Timestamp.valueOf(localDateTime);
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
            // Récupérer les items du panier
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] prices = request.getParameterValues("price[]");

            if (productIds == null || productIds.length == 0) {
                throw new IllegalArgumentException("Le panier est vide");
            }

            // Créer les items et calculer les totaux
            List<SaleItem> items = new ArrayList<>();
            BigDecimal subtotal = BigDecimal.ZERO;

            for (int i = 0; i < productIds.length; i++) {
                Integer productId = Integer.parseInt(productIds[i]);
                Integer quantity = Integer.parseInt(quantities[i]);
                BigDecimal price = new BigDecimal(prices[i]);

                // Trouver le meilleur lot pour ce produit
                Inventory bestBatch = inventoryService.findBestBatchForProduct(productId, quantity);
                if (bestBatch == null) {
                    Product product = productService.getProductById(productId);
                    String productName = product != null ? product.getProductName() : "ID: " + productId;
                    throw new IllegalArgumentException("Stock insuffisant pour le produit: " + productName);
                }

                BigDecimal lineTotal = price.multiply(new BigDecimal(quantity));
                subtotal = subtotal.add(lineTotal);

                SaleItem item = new SaleItem();
                item.setProductId(productId);
                item.setInventoryId(bestBatch.getInventoryId());
                item.setQuantity(quantity);
                item.setUnitPrice(price.doubleValue());
                item.setDiscount(0.0);
                item.setLineTotal(lineTotal.doubleValue());

                items.add(item);
            }

            // Créer l'objet Sale avec tous les calculs
            Sale sale = new Sale();

            // Client (peut être null pour vente sans client)
            String customerIdStr = request.getParameter("customerId");
            if (customerIdStr != null && !customerIdStr.isEmpty()) {
                try {
                    sale.setCustomerId(Integer.parseInt(customerIdStr));
                } catch (NumberFormatException e) {
                    sale.setCustomerId(null);
                }
            }

            // Calculs financiers
            String discountStr = request.getParameter("discount");
            BigDecimal discountAmount = BigDecimal.ZERO;
            if (discountStr != null && !discountStr.isEmpty()) {
                try {
                    discountAmount = new BigDecimal(discountStr);
                    if (discountAmount.compareTo(BigDecimal.ZERO) < 0) {
                        discountAmount = BigDecimal.ZERO;
                    }
                } catch (NumberFormatException e) {
                    discountAmount = BigDecimal.ZERO;
                }
            }

            BigDecimal taxAmount = BigDecimal.ZERO;
            BigDecimal totalAmount = subtotal.subtract(discountAmount).add(taxAmount);

            // Vérifier que le total est positif
            if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Le montant total doit être positif. Vérifiez la remise.");
            }

            sale.setSubtotal(subtotal.doubleValue());
            sale.setDiscountAmount(discountAmount.doubleValue());
            sale.setTaxAmount(taxAmount.doubleValue());
            sale.setTotalAmount(totalAmount.doubleValue());

            // Date de vente
            sale.setSaleDate(LocalDateTime.now());

            // Méthode de paiement
            String paymentMethod = request.getParameter("paymentMethod");
            sale.setPaymentMethod(paymentMethod != null ? paymentMethod : "cash");
            sale.setPaymentStatus("paid");

            // Servi par
            String servedBy = request.getParameter("servedBy");
            if (servedBy == null || servedBy.trim().isEmpty()) {
                HttpSession session = request.getSession();
                if (session != null) {
                    String username = (String) session.getAttribute("username");
                    sale.setServedBy(username != null ? username : "System");
                } else {
                    sale.setServedBy("System");
                }
            }

            // Notes
            String notes = request.getParameter("notes");
            sale.setNotes(notes);

            // Créer la vente

            Integer saleId = saleService.createSale(sale, items);

            if (saleId != null) {
                // Récupérer les options d'impression
                String printReceipt = request.getParameter("printReceipt");
                String printThermal = request.getParameter("printThermal"); // Nouveau paramètre

                String redirectUrl = request.getContextPath() + "/sales/view?id=" + saleId + "&success=true";

                if ("on".equals(printReceipt)) {
                    redirectUrl += "&print=true";
                }

                // Si impression thermique demandée
                if ("on".equals(printThermal)) {
                    redirectUrl += "&printThermal=true";
                }

                response.sendRedirect(redirectUrl);
            } else {
                throw new Exception("Échec de la création de la vente");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur de format des données: " + e.getMessage());
            showNewSaleForm(request, response);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            showNewSaleForm(request, response);
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
                SaleDAO saleDAO = new SaleDAOImpl();
                List<SaleItem> items = saleDAO.findItemsBySaleId(saleId);

                request.setAttribute("sale", sale);
                request.setAttribute("items", items);

                // CORRECTION : Gestion de l'impression thermique
                String printThermal = request.getParameter("printThermal");

                if ("true".equals(printThermal)) {
                    // Rediriger vers le servlet de ticket thermique pour impression directe
                    response.sendRedirect(request.getContextPath() +
                            "/sales/thermal-ticket?id=" + saleId);
                    return;
                }

                // Vérifier si on doit imprimer le reçu HTML normal
                if ("true".equals(request.getParameter("print"))) {
                    request.setAttribute("printMode", true);
                }

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

    private void exportSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.getWriter().println("<h1>Export PDF (À implémenter)</h1>");
        response.getWriter().println("<p>Fonctionnalité d'export PDF à implémenter.</p>");
    }

    private void completeSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer saleId = Integer.parseInt(request.getParameter("id"));
            boolean success = saleService.updateSaleStatus(saleId, "paid");

            if (success) {
                response.sendRedirect(request.getContextPath() + "/sales?success=Vente+marquée+comme+payée");
            } else {
                response.sendRedirect(request.getContextPath() + "/sales?error=Échec+de+la+mise+à+jour");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sales?error=ID+invalide");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/sales?error=Erreur:+" + e.getMessage());
        }
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

    private void showSalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate startDate = LocalDate.now().minusDays(30);
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

        List<Object[]> topProducts = saleService.getTopProducts(10);

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

    private void getSalesStatsAPI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            SalesSummary summary = saleService.getTodaySummary();
            LocalDate today = LocalDate.now();
            LocalDate firstDayOfMonth = today.withDayOfMonth(1);
            LocalDate lastDayOfMonth = today.withDayOfMonth(today.lengthOfMonth());
            Double monthSales = saleService.getTotalRevenue(firstDayOfMonth, lastDayOfMonth);

            StatsDTO stats = new StatsDTO();
            stats.todaySales = summary != null ? summary.getRevenue() : 0.0;
            stats.monthSales = monthSales != null ? monthSales : 0.0;
            stats.totalTransactions = summary != null ? summary.getTransactions() : 0;
            stats.avgTicket = summary != null && summary.getTransactions() > 0 ?
                    summary.getRevenue() / summary.getTransactions() : 0.0;

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(stats));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
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

    private static class StatsDTO {
        Double todaySales;
        Double monthSales;
        Integer totalTransactions;
        Double avgTicket;
    }
}