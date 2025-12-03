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
    
    // Annuler une vente (remboursement)
    public boolean cancelSale(Integer saleId) {
        try {
            // Récupérer les items de la vente
            List<SaleItem> items = saleDAO.findItemsBySaleId(saleId);
            
            // Restaurer le stock pour chaque item
            for (SaleItem item : items) {
                // Trouver le lot d'inventaire
                Inventory inventory = inventoryDAO.findById(item.getInventoryId());
                if (inventory != null) {
                    inventory.setQuantityInStock(inventory.getQuantityInStock() + item.getQuantity());
                    inventoryDAO.update(inventory);
                }
            }
            
            // Marquer la vente comme remboursée
            Sale sale = saleDAO.findSaleById(saleId);
            if (sale != null) {
                sale.setPaymentStatus("refunded");
                saleDAO.updateSale(sale);
                return true;
            }
            
        } catch (Exception e) {
            System.err.println("Erreur annulation vente: " + e.getMessage());
        }
        return false;
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
}