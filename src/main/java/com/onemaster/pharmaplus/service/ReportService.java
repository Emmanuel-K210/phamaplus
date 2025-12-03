package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.*;
import com.onemaster.pharmaplus.model.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

public class ReportService {

    private final ReportDAOImpl reportDAO;
    private final SaleDAOImpl saleDAO;
    private final ProductDAOImpl productDAO;
    private final CustomerDAOImpl customerDAO;
    private final PrescriptionDAOImpl prescriptionDAO;
    private final Gson gson;

    public ReportService() {
        this.reportDAO = new ReportDAOImpl();
        this.saleDAO = new SaleDAOImpl();
        this.productDAO = new ProductDAOImpl();
        this.customerDAO = new CustomerDAOImpl();
        this.prescriptionDAO = new PrescriptionDAOImpl();
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    // ============ MÉTHODES CRUD POUR LES RAPPORTS ============

    public Report saveReport(Report report) {
        if (report.getReportId() == null) {
            reportDAO.insert(report);
        } else {
            reportDAO.update(report);
        }
        return report;
    }

    public void deleteReport(Integer reportId) {
        reportDAO.delete(reportId);
    }

    public Report getReportById(Integer reportId) {
        return reportDAO.findById(reportId);
    }

    public List<Report> getAllReports() {
        return reportDAO.findAll();
    }

    public List<Report> getReportsByType(String reportType) {
        return reportDAO.findByType(reportType);
    }

    public List<Report> getRecentReports(int limit) {
        return reportDAO.findRecentReports(limit);
    }

    // ============ GÉNÉRATEURS DE RAPPORTS ============

    /**
     * Génère un rapport détaillé des ventes pour une période donnée
     */
    public Report generateSalesReport(LocalDate startDate, LocalDate endDate, String format) {
        Report report = createBaseReport("SALES",
                "Rapport des ventes du " + startDate + " au " + endDate,
                "Rapport détaillé des ventes avec statistiques et analyses",
                startDate, endDate, format);

        try {
            List<Sale> sales = saleDAO.findSalesByDateRange(startDate, endDate);

            // Calculs statistiques
            double totalRevenue = sales.stream()
                    .mapToDouble(Sale::getTotalAmount)
                    .sum();

            int totalItemsSold = sales.stream()
                    .mapToInt(s -> s.getItems() != null ? s.getItems().size() : 0)
                    .sum();

            int numberOfSales = sales.size();
            double averageSaleValue = numberOfSales > 0 ? totalRevenue / numberOfSales : 0;

            // Top produits vendus
            Map<String, Integer> productSales = new HashMap<>();
            for (Sale sale : sales) {
                if (sale.getItems() != null) {
                    sale.getItems().forEach(item -> {
                        String productName = item.getProductName();
                        productSales.merge(productName, item.getQuantity(), Integer::sum);
                    });
                }
            }

            List<Map<String, Object>> topProducts = productSales.entrySet().stream()
                    .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                    .limit(10)
                    .map(entry -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("product", entry.getKey());
                        map.put("quantity", entry.getValue());
                        return map;
                    })
                    .collect(Collectors.toList());

            // Résumé
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalRevenue", totalRevenue);
            summary.put("totalItemsSold", totalItemsSold);
            summary.put("numberOfSales", numberOfSales);
            summary.put("averageSaleValue", averageSaleValue);
            summary.put("period", startDate + " au " + endDate);

            // Détails des ventes
            List<Map<String, Object>> details = sales.stream()
                    .map(sale -> {
                        Map<String, Object> saleMap = new HashMap<>();
                        saleMap.put("saleId", sale.getSaleId());
                        saleMap.put("date", sale.getSaleDate());
                        saleMap.put("customer", sale.getCustomerName());
                        saleMap.put("totalAmount", sale.getTotalAmount());
                        saleMap.put("paymentMethod", sale.getPaymentMethod());
                        return saleMap;
                    })
                    .collect(Collectors.toList());

            report.setSummary(summary);
            report.setDetails(details);

            // Données supplémentaires
            Map<String, Object> data = new HashMap<>();
            data.put("topProducts", topProducts);
            data.put("salesByDay", calculateSalesByDay(sales, startDate, endDate));
            data.put("paymentMethods", calculatePaymentMethods(sales));

            report.setData(convertToJson(data));
            report.setStatus("COMPLETED");

        } catch (Exception e) {
            handleReportError(report, e);
        }

        return saveReport(report);
    }

    /**
     * Génère un rapport de l'état des stocks
     * CORRIGÉ : Utilise reorderLevel au lieu de minimumStock
     */
    public Report generateStockReport(String format) {
        Report report = createBaseReport("STOCK",
                "Rapport de stock au " + LocalDate.now(),
                "État des stocks et produits à réapprovisionner",
                LocalDate.now(), LocalDate.now(), format);

        try {
            List<Product> products = productDAO.findAll();

            // Statistiques - CORRECTION: Utilisation de reorderLevel
            int totalProducts = products.size();
            int lowStockProducts = (int) products.stream()
                    .filter(p -> getStockQuantity(p) < p.getReorderLevel())
                    .count();

            int outOfStockProducts = (int) products.stream()
                    .filter(p -> getStockQuantity(p) <= 0)
                    .count();

            double totalStockValue = products.stream()
                    .mapToDouble(p -> getStockQuantity(p) * p.getSellingPrice())
                    .sum();

            // Produits à réapprovisionner
            List<Map<String, Object>> toReorder = products.stream()
                    .filter(p -> getStockQuantity(p) < p.getReorderLevel())
                    .sorted(Comparator.comparingInt(this::getStockQuantity))
                    .map(p -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("productId", p.getProductId());
                        map.put("productName", p.getProductName());
                        map.put("currentStock", getStockQuantity(p));
                        map.put("reorderLevel", p.getReorderLevel());
                        map.put("shortage", p.getReorderLevel() - getStockQuantity(p));
                        return map;
                    })
                    .collect(Collectors.toList());

            // Résumé
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalProducts", totalProducts);
            summary.put("lowStockProducts", lowStockProducts);
            summary.put("outOfStockProducts", outOfStockProducts);
            summary.put("totalStockValue", totalStockValue);
            summary.put("reorderPercentage", totalProducts > 0 ?
                    (double) lowStockProducts / totalProducts * 100 : 0);
            summary.put("reportDate", LocalDate.now());

            // Détails
            List<Map<String, Object>> details = products.stream()
                    .map(p -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("productId", p.getProductId());
                        map.put("productName", p.getProductName());
                        map.put("category", p.getCategoryName());
                        map.put("currentStock", getStockQuantity(p));
                        map.put("reorderLevel", p.getReorderLevel());
                        map.put("status", getStockStatus(p));
                        map.put("value", getStockQuantity(p) * p.getSellingPrice());
                        map.put("manufacturer", p.getManufacturer());
                        return map;
                    })
                    .collect(Collectors.toList());

            report.setSummary(summary);
            report.setDetails(details);

            Map<String, Object> data = new HashMap<>();
            data.put("toReorder", toReorder);
            data.put("stockByCategory", calculateStockByCategory(products));

            report.setData(convertToJson(data));
            report.setStatus("COMPLETED");

        } catch (Exception e) {
            handleReportError(report, e);
        }

        return saveReport(report);
    }

    /**
     * Génère un rapport d'analyse de la clientèle
     */
    public Report generateCustomerReport(LocalDate startDate, LocalDate endDate, String format) {
        Report report = createBaseReport("CUSTOMER",
                "Rapport clients du " + startDate + " au " + endDate,
                "Analyse de la clientèle et comportements d'achat",
                startDate, endDate, format);

        try {
            List<Customer> customers = customerDAO.findAll();
            List<Sale> sales = saleDAO.findSalesByDateRange(startDate, endDate);

            // Statistiques
            int totalCustomers = customers.size();
            int newCustomers = (int) customers.stream()
                    .filter(c -> c.getCreatedAt() != null &&
                            !c.getCreatedAt().toLocalDate().isBefore(startDate))
                    .count();

            Set<Integer> activeCustomerIds = sales.stream()
                    .map(Sale::getCustomerId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());

            int activeCustomers = activeCustomerIds.size();

            // Chiffre d'affaires par client
            Map<Integer, Double> customerRevenue = new HashMap<>();
            for (Sale sale : sales) {
                if (sale.getCustomerId() != null) {
                    customerRevenue.merge(sale.getCustomerId(),
                            sale.getTotalAmount(), Double::sum);
                }
            }

            // Top clients
            List<Map<String, Object>> topCustomers = customerRevenue.entrySet().stream()
                    .sorted(Map.Entry.<Integer, Double>comparingByValue().reversed())
                    .limit(10)
                    .map(entry -> {
                        Customer customer = customerDAO.findById(entry.getKey());
                        Map<String, Object> map = new HashMap<>();
                        map.put("customerId", entry.getKey());
                        map.put("customerName", customer != null ?
                                customer.getFirstName() + " " + customer.getLastName() : "N/A");
                        map.put("totalSpent", entry.getValue());
                        map.put("numberOfPurchases", countPurchases(sales, entry.getKey()));
                        return map;
                    })
                    .collect(Collectors.toList());

            // Résumé
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalCustomers", totalCustomers);
            summary.put("newCustomers", newCustomers);
            summary.put("activeCustomers", activeCustomers);
            summary.put("retentionRate", totalCustomers > 0 ?
                    (double) activeCustomers / totalCustomers * 100 : 0);
            summary.put("averageSpentPerCustomer", activeCustomers > 0 ?
                    customerRevenue.values().stream().mapToDouble(Double::doubleValue).sum() / activeCustomers : 0);
            summary.put("period", startDate + " au " + endDate);

            // Détails
            List<Map<String, Object>> details = customers.stream()
                    .map(c -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("customerId", c.getCustomerId());
                        map.put("customerName", c.getFirstName() + " " + c.getLastName());
                        map.put("phone", c.getPhone());
                        map.put("email", c.getEmail());
                        map.put("registrationDate", c.getCreatedAt());
                        map.put("totalPurchases", countPurchases(sales, c.getCustomerId()));
                        map.put("totalSpent", customerRevenue.getOrDefault(c.getCustomerId(), 0.0));
                        map.put("isActive", activeCustomerIds.contains(c.getCustomerId()));
                        return map;
                    })
                    .collect(Collectors.toList());

            report.setSummary(summary);
            report.setDetails(details);

            Map<String, Object> data = new HashMap<>();
            data.put("topCustomers", topCustomers);
            data.put("customersByMonth", calculateNewCustomersByMonth(customers));

            report.setData(convertToJson(data));
            report.setStatus("COMPLETED");

        } catch (Exception e) {
            handleReportError(report, e);
        }

        return saveReport(report);
    }

    /**
     * Génère un rapport financier complet
     */
    public Report generateFinancialReport(LocalDate startDate, LocalDate endDate, String format) {
        Report report = createBaseReport("FINANCIAL",
                "Rapport financier du " + startDate + " au " + endDate,
                "Analyse financière détaillée avec tendances",
                startDate, endDate, format);

        try {
            List<Sale> sales = saleDAO.findSalesByDateRange(startDate, endDate);

            double totalRevenue = sales.stream()
                    .mapToDouble(Sale::getTotalAmount)
                    .sum();

            // Par mode de paiement
            Map<String, Double> revenueByPayment = sales.stream()
                    .collect(Collectors.groupingBy(
                            Sale::getPaymentMethod,
                            Collectors.summingDouble(Sale::getTotalAmount)
                    ));

            // Par jour
            Map<LocalDate, Double> revenueByDay = sales.stream()
                    .collect(Collectors.groupingBy(
                           s-> s.getSaleDate().toLocalDate(),
                            Collectors.summingDouble(Sale::getTotalAmount)
                    ));

            double averageDailyRevenue = revenueByDay.values().stream()
                    .mapToDouble(Double::doubleValue)
                    .average()
                    .orElse(0.0);

            double bestDayRevenue = revenueByDay.values().stream()
                    .mapToDouble(Double::doubleValue)
                    .max()
                    .orElse(0.0);

            // Résumé
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalRevenue", totalRevenue);
            summary.put("averageDailyRevenue", averageDailyRevenue);
            summary.put("bestDayRevenue", bestDayRevenue);
            summary.put("numberOfTransactions", sales.size());
            summary.put("averageTransactionValue", sales.size() > 0 ?
                    totalRevenue / sales.size() : 0);
            summary.put("period", startDate + " au " + endDate);

            // Détails par jour
            List<Map<String, Object>> details = revenueByDay.entrySet().stream()
                    .sorted(Map.Entry.comparingByKey())
                    .map(entry -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("date", entry.getKey());
                        map.put("revenue", entry.getValue());
                        map.put("numberOfSales", countSalesByDay(sales, entry.getKey()));
                        return map;
                    })
                    .collect(Collectors.toList());

            report.setSummary(summary);
            report.setDetails(details);

            Map<String, Object> data = new HashMap<>();
            data.put("revenueByPaymentMethod", revenueByPayment);
            data.put("revenueByDay", revenueByDay);
            data.put("topSellingDays", getTopSellingDays(revenueByDay, 5));

            report.setData(convertToJson(data));
            report.setStatus("COMPLETED");

        } catch (Exception e) {
            handleReportError(report, e);
        }

        return saveReport(report);
    }

    /**
     * Génère un rapport des ordonnances médicales
     */
    public Report generatePrescriptionReport(LocalDate startDate, LocalDate endDate, String format) {
        Report report = createBaseReport("PRESCRIPTION",
                "Rapport des ordonnances du " + startDate + " au " + endDate,
                "Analyse des prescriptions et médicaments prescrits",
                startDate, endDate, format);

        try {
            List<Prescription> prescriptions = prescriptionDAO.findByDateRange(startDate, endDate);

            int totalPrescriptions = prescriptions.size();
            int prescriptionsFilled = (int) prescriptions.stream()
                    .filter(Prescription::isFilled)
                    .count();
            int prescriptionsPending = totalPrescriptions - prescriptionsFilled;

            // Par médecin
            Map<String, Long> prescriptionsByDoctor = prescriptions.stream()
                    .collect(Collectors.groupingBy(
                            Prescription::getDoctorName,
                            Collectors.counting()
                    ));

            // Médicaments prescrits
            Map<String, Long> medicationsPrescribed = new HashMap<>();
            for (Prescription prescription : prescriptions) {
                if (prescription.getMedications() != null) {
                    prescription.getMedications().forEach(med -> {
                        medicationsPrescribed.merge(med.getName(), 1L, Long::sum);
                    });
                }
            }

            // Résumé
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalPrescriptions", totalPrescriptions);
            summary.put("prescriptionsFilled", prescriptionsFilled);
            summary.put("prescriptionsPending", prescriptionsPending);
            summary.put("fillRate", totalPrescriptions > 0 ?
                    (double) prescriptionsFilled / totalPrescriptions * 100 : 0);
            summary.put("uniqueDoctors", prescriptionsByDoctor.size());
            summary.put("period", startDate + " au " + endDate);

            // Détails
            List<Map<String, Object>> details = prescriptions.stream()
                    .map(p -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("prescriptionId", p.getPrescriptionId());
                        map.put("customerName", p.getCustomerName());
                        map.put("doctorName", p.getDoctorName());
                        map.put("date", p.getPrescriptionDate());
                        map.put("status", p.isFilled() ? "Honorée" : "En attente");
                        map.put("numberOfMedications", p.getMedications() != null ?
                                p.getMedications().size() : 0);
                        return map;
                    })
                    .collect(Collectors.toList());

            report.setSummary(summary);
            report.setDetails(details);

            Map<String, Object> data = new HashMap<>();
            data.put("prescriptionsByDoctor", prescriptionsByDoctor);
            data.put("topMedications", medicationsPrescribed.entrySet().stream()
                    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                    .limit(10)
                    .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue)));

            report.setData(convertToJson(data));
            report.setStatus("COMPLETED");

        } catch (Exception e) {
            handleReportError(report, e);
        }

        return saveReport(report);
    }

    // ============ MÉTHODES UTILITAIRES ============

    /**
     * NOUVELLE MÉTHODE: Récupère la quantité en stock
     * À adapter selon votre implémentation réelle
     */
    private int getStockQuantity(Product product) {
        // TODO: Implémenter selon votre logique de gestion des stocks
        // Option 1: Si vous avez une table Inventory séparée
        // Option 2: Si c'est dans Product, ajouter le champ
        // Pour l'instant, retourne 0 par défaut
        return 0; // À REMPLACER
    }

    /**
     * Détermine le statut du stock d'un produit
     */
    private String getStockStatus(Product product) {
        int quantity = getStockQuantity(product);
        if (quantity <= 0) {
            return "RUPTURE";
        } else if (quantity < product.getReorderLevel()) {
            return "STOCK BAS";
        } else {
            return "OK";
        }
    }

    /**
     * Calcule la valeur du stock par catégorie
     */
    private Map<String, Double> calculateStockByCategory(List<Product> products) {
        return products.stream()
                .collect(Collectors.groupingBy(
                        Product::getCategoryName,
                        Collectors.summingDouble(p -> getStockQuantity(p) * p.getSellingPrice())
                ));
    }

    /**
     * Calcule les ventes par jour
     */
    private Map<String, Double> calculateSalesByDay(List<Sale> sales, LocalDate start, LocalDate end) {
        Map<String, Double> result = new LinkedHashMap<>();

        LocalDate current = start;
        while (!current.isAfter(end)) {
            final LocalDate date = current;
            double dailySales = sales.stream()
                    .filter(s -> s.getSaleDate().equals(date))
                    .mapToDouble(Sale::getTotalAmount)
                    .sum();
            result.put(date.toString(), dailySales);
            current = current.plusDays(1);
        }

        return result;
    }

    /**
     * Calcule la répartition par mode de paiement
     */
    private Map<String, Integer> calculatePaymentMethods(List<Sale> sales) {
        return sales.stream()
                .collect(Collectors.groupingBy(
                        Sale::getPaymentMethod,
                        Collectors.summingInt(s -> 1)
                ));
    }

    /**
     * Compte le nombre d'achats d'un client
     */
    private int countPurchases(List<Sale> sales, Integer customerId) {
        return (int) sales.stream()
                .filter(s -> customerId.equals(s.getCustomerId()))
                .count();
    }

    /**
     * Compte les ventes par jour
     */
    private int countSalesByDay(List<Sale> sales, LocalDate date) {
        return (int) sales.stream()
                .filter(s -> s.getSaleDate().equals(date))
                .count();
    }

    /**
     * Calcule les nouveaux clients par mois
     */
    private Map<String, Long> calculateNewCustomersByMonth(List<Customer> customers) {
        return customers.stream()
                .filter(c -> c.getCreatedAt() != null)
                .collect(Collectors.groupingBy(
                        c -> c.getCreatedAt().getMonth().toString(),
                        Collectors.counting()
                ));
    }

    /**
     * Retourne les meilleurs jours de vente
     */
    private List<Map<String, Object>> getTopSellingDays(Map<LocalDate, Double> revenueByDay, int limit) {
        return revenueByDay.entrySet().stream()
                .sorted(Map.Entry.<LocalDate, Double>comparingByValue().reversed())
                .limit(limit)
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("date", entry.getKey());
                    map.put("revenue", entry.getValue());
                    return map;
                })
                .collect(Collectors.toList());
    }

    /**
     * Convertit un objet en JSON
     */
    private String convertToJson(Object obj) {
        try {
            return gson.toJson(obj);
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }

    /**
     * Crée un rapport de base avec les informations communes
     */
    private Report createBaseReport(String type, String name, String description,
                                    LocalDate startDate, LocalDate endDate, String format) {
        Report report = new Report();
        report.setReportType(type);
        report.setReportName(name);
        report.setDescription(description);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        report.setFormat(format != null ? format : "JSON");
        report.setStatus("GENERATING");
        report.setGeneratedAt(LocalDateTime.now());
        return report;
    }

    /**
     * Gère les erreurs de génération de rapport
     */
    private void handleReportError(Report report, Exception e) {
        report.setStatus("FAILED");
        report.setDescription("Erreur lors de la génération: " + e.getMessage());
        e.printStackTrace(); // En production, utilisez un logger approprié
    }

    // ============ MÉTHODES D'EXPORT (À IMPLÉMENTER) ============

    /**
     * Exporte un rapport en PDF
     */
    public byte[] exportReportToPdf(Report report) {
        // TODO: Implémenter avec iText ou Apache PDFBox
        throw new UnsupportedOperationException("Export PDF non implémenté");
    }

    /**
     * Exporte un rapport en Excel
     */
    public byte[] exportReportToExcel(Report report) {
        // TODO: Implémenter avec Apache POI
        throw new UnsupportedOperationException("Export Excel non implémenté");
    }

    /**
     * Génère un rapport personnalisé
     */
    public Report generateCustomReport(String reportType, Map<String, Object> parameters) {
        // TODO: Implémenter selon les besoins spécifiques
        throw new UnsupportedOperationException("Rapport personnalisé non implémenté");
    }
}