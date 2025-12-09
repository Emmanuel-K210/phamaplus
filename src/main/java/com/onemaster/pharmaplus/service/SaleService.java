package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.InventoryDAOImpl;
import com.onemaster.pharmaplus.dao.impl.SaleDAOImpl;
import com.onemaster.pharmaplus.dao.service.InventoryDAO;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.Inventory;
import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleItem;
import com.onemaster.pharmaplus.utils.SalesSummary;

import java.time.LocalDate;
import java.util.List;

public class SaleService {
    
    private final SaleDAO saleDAO;
    private final InventoryDAO inventoryDAO;
    private final ProductService productService;
    private final CustomerService customerService;
    
    public SaleService() {
        this.saleDAO = new SaleDAOImpl();
        this.inventoryDAO = new InventoryDAOImpl();
        this.productService = new ProductService();
        this.customerService = new CustomerService();
    }
    
    // Méthode principale pour créer une vente
    public Integer createSale(Sale sale, List<SaleItem> items) {
        // Validation
        validateSale(sale);
        validateSaleItems(items);
        
        // Calculer les totaux
        calculateSaleTotals(sale, items);
        
        // Démarrer une transaction (simulée - pour un projet réel, utilisez des transactions JDBC)
        try {
            // 1. Enregistrer la vente
            Integer saleId = saleDAO.insertSale(sale);
            if (saleId == null) {
                throw new RuntimeException("Échec de l'insertion de la vente");
            }
            
            sale.setSaleId(saleId);
            
            // 2. Enregistrer chaque item et mettre à jour l'inventaire
            for (SaleItem item : items) {
                item.setSaleId(saleId);
                saleDAO.insertSaleItem(item);
                
                // Mettre à jour l'inventaire
                boolean success = inventoryDAO.consumeStock(
                    item.getInventoryId(), 
                    item.getQuantity()
                );
                
                if (!success) {
                    throw new RuntimeException("Stock insuffisant pour le produit: " + item.getProductName());
                }
            }
            
            return saleId;
            
        } catch (Exception e) {
            // Rollback simulé
            System.err.println("Erreur lors de la vente: " + e.getMessage());
            throw new RuntimeException("Échec de la transaction de vente: " + e.getMessage());
        }
    }

    public Sale findById(Integer saleId) {
        return saleDAO.findSaleById(saleId);
    }
    
    // Récupérer une vente avec ses items
    public Sale getSaleWithItems(Integer saleId) {
        Sale sale = saleDAO.findSaleById(saleId);
        if (sale != null) {
            List<SaleItem> items = saleDAO.findItemsBySaleId(saleId);
            sale.setTotalItems(items.size());
            // Pourrait ajouter les items à un objet wrapper
        }
        return sale;
    }
    
    // Recherches
    public List<Sale> getSalesByDate(LocalDate date) {
        return saleDAO.findSalesByDate(date);
    }
    
    public List<Sale> getSalesByDateRange(LocalDate start, LocalDate end) {
        return saleDAO.findSalesByDateRange(start, end);
    }
    
    public List<Sale> getSalesByCustomer(Integer customerId) {
        return saleDAO.findSalesByCustomer(customerId);
    }
    
    // Statistiques
    public Double getDailyRevenue(LocalDate date) {
        return saleDAO.getTotalRevenue(date, date);
    }
    
    public Double getMonthlyRevenue(int year, int month) {
        LocalDate start = LocalDate.of(year, month, 1);
        LocalDate end = start.withDayOfMonth(start.lengthOfMonth());
        return saleDAO.getTotalRevenue(start, end);
    }
    
    public List<Object[]> getTopProducts(int limit) {
        return saleDAO.getTopSellingProducts(limit);
    }
    
    // Pour dashboard
    public SalesSummary getTodaySummary() {
        SalesSummary summary = new SalesSummary();
        summary.setRevenue(saleDAO.getTodayRevenue());
        summary.setTransactions(saleDAO.getTodayTransactions());
        summary.setItemsSold(saleDAO.getTotalItemsSold(LocalDate.now(), LocalDate.now()));
        return summary;
    }
    
    public List<Sale> getRecentSales(int limit) {
        return saleDAO.getRecentSales(limit);
    }
    
    // Validation
    private void validateSale(Sale sale) {
        if (sale.getTotalAmount() <= 0) {
            throw new IllegalArgumentException("Le montant total doit être positif");
        }
        if (sale.getPaymentMethod() == null || sale.getPaymentMethod().trim().isEmpty()) {
            throw new IllegalArgumentException("La méthode de paiement est requise");
        }
        // Valider les méthodes de paiement autorisées
        List<String> allowedMethods = List.of("cash", "card", "insurance", "mobile_payment");
        if (!allowedMethods.contains(sale.getPaymentMethod())) {
            throw new IllegalArgumentException("Méthode de paiement non valide");
        }
    }
    
    private void validateSaleItems(List<SaleItem> items) {
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Une vente doit contenir au moins un produit");
        }
        
        for (SaleItem item : items) {
            if (item.getQuantity() <= 0) {
                throw new IllegalArgumentException("La quantité doit être positive pour: " + item.getProductName());
            }
            if (item.getUnitPrice() <= 0) {
                throw new IllegalArgumentException("Le prix unitaire doit être positif pour: " + item.getProductName());
            }
            
            // Vérifier le stock disponible
            int availableStock = inventoryDAO.getAvailableStockQuantity(item.getProductId());
            if (availableStock < item.getQuantity()) {
                throw new IllegalArgumentException("Stock insuffisant pour: " + item.getProductName() + 
                                                 ". Disponible: " + availableStock + ", Demandé: " + item.getQuantity());
            }
        }
    }
    
    // Calcul des totaux
    private void calculateSaleTotals(Sale sale, List<SaleItem> items) {
        double subtotal = 0.0;
        
        for (SaleItem item : items) {
            // Calculer le line_total si non déjà calculé
            if (item.getLineTotal() == null) {
                double lineTotal = item.getQuantity() * item.getUnitPrice();
                lineTotal -= (item.getDiscount() != null ? item.getDiscount() : 0.0);
                item.setLineTotal(lineTotal);
            }
            subtotal += item.getLineTotal();
        }
        
        sale.setSubtotal(subtotal);
        
        // Appliquer la remise globale si elle existe
        double discount = sale.getDiscountAmount() != null ? sale.getDiscountAmount() : 0.0;
        double afterDiscount = subtotal - discount;
        
        // Calculer la taxe (simplifié - 20% par défaut)
        double taxRate = 0.20; // 20% TVA
        double tax = afterDiscount * taxRate;
        
        sale.setTaxAmount(tax);
        sale.setTotalAmount(afterDiscount + tax);
    }

    /**
     * Récupère le revenu total sur une période
     */
    public Double getTotalRevenue(LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Les dates de début et fin sont requises");
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("La date de début doit être avant la date de fin");
        }

        return saleDAO.getTotalRevenue(startDate, endDate);
    }

    /**
     * Récupère le nombre total d'articles vendus sur une période
     */
    public Integer getTotalItemsSold(LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Les dates de début et fin sont requises");
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("La date de début doit être avant la date de fin");
        }

        return saleDAO.getTotalItemsSold(startDate, endDate);
    }

    /**
     * Met à jour le statut d'une vente
     * @param saleId ID de la vente
     * @param newStatus Nouveau statut (paid, pending, cancelled, etc.)
     * @return true si mis à jour avec succès
     */
    public boolean updateSaleStatus(Integer saleId, String newStatus) {
        if (saleId == null || newStatus == null || newStatus.trim().isEmpty()) {
            return false;
        }

        try {
            // Vérifier d'abord si la vente existe
            Sale sale = saleDAO.findSaleById(saleId);
            if (sale == null) {
                System.err.println("Vente non trouvée avec l'ID: " + saleId);
                return false;
            }

            // Valider la transition de statut
            if (!isValidStatusTransition(sale.getPaymentStatus(), newStatus)) {
                System.err.println("Transition de statut invalide: " +
                        sale.getPaymentStatus() + " -> " + newStatus);
                return false;
            }

            // Mettre à jour le statut
            boolean updated = saleDAO.updateStatus(saleId, newStatus);

            if (updated) {
                System.out.println("Statut de la vente #" + saleId + " mis à jour de '" +
                        sale.getPaymentStatus() + "' à '" + newStatus + "'");

                // Journaliser l'action si nécessaire
                logStatusChange(saleId, sale.getPaymentStatus(), newStatus);
            }

            return updated;

        } catch (Exception e) {
            System.err.println("Erreur lors de la mise à jour du statut: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Vérifie si la transition de statut est valide
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }

        // Définir les transitions autorisées
        switch (currentStatus.toLowerCase()) {
            case "pending":
                // En attente peut devenir payée ou annulée
                return newStatus.equalsIgnoreCase("paid") ||
                        newStatus.equalsIgnoreCase("cancelled");

            case "paid":
                // Payée peut être remboursée
                return newStatus.equalsIgnoreCase("refunded");

            case "cancelled":
                // Annulée ne peut pas changer
                return false;

            case "refunded":
                // Remboursée ne peut pas changer
                return false;

            default:
                // Pour les autres statuts, permettre tout changement
                return true;
        }
    }

    /**
     * Journalise le changement de statut
     */
    private void logStatusChange(Integer saleId, String oldStatus, String newStatus) {
        // Vous pouvez implémenter une journalisation dans une table d'audit
        // ou simplement logger l'action
        String logMessage = String.format(
                "Vente #%d: Statut changé de '%s' à '%s'",
                saleId, oldStatus, newStatus
        );
        System.out.println(logMessage);

        // Exemple d'insertion dans une table d'audit
        /*
        try {
            String sql = "INSERT INTO sale_status_history (sale_id, old_status, new_status, changed_at, changed_by) " +
                        "VALUES (?, ?, ?, NOW(), ?)";
            // Exécuter l'insertion...
        } catch (Exception e) {
            System.err.println("Erreur lors de la journalisation: " + e.getMessage());
        }
        */
    }

    /**
     * Vérifie si une vente existe avec un ID et un statut spécifiques
     * @param saleId ID de la vente
     * @param status Statut à vérifier
     * @return true si la vente existe avec ce statut
     */
    public Boolean findSalesByIdAndStatus(Integer saleId, String status) {
        if (saleId == null || status == null) {
            return false;
        }

        try {
            return saleDAO.existsByIdAndStatus(saleId, status);
        } catch (Exception e) {
            System.err.println("Erreur lors de la vérification: " + e.getMessage());
            return false;
        }
    }

    /**
     * Marque une vente comme payée
     * @param saleId ID de la vente
     * @return true si réussite
     */
    public boolean markAsPaid(Integer saleId) {
        return updateSaleStatus(saleId, "paid");
    }

    /**
     * Annule une vente
     * @param saleId ID de la vente
     * @return true si réussite
     */
    public boolean cancelSale(Integer saleId) {
        return updateSaleStatus(saleId, "cancelled");
    }

    /**
     * Marque une vente comme remboursée
     * @param saleId ID de la vente
     * @return true si réussite
     */
    public boolean refundSale(Integer saleId) {
        return updateSaleStatus(saleId, "refunded");
    }
}