package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.InventoryDAOImpl;
import com.onemaster.pharmaplus.dao.service.InventoryDAO;
import com.onemaster.pharmaplus.model.Inventory;

import java.time.LocalDate;
import java.util.List;

public class InventoryService {

    private final InventoryDAO inventoryDAO;
    private static final int DEFAULT_LOW_STOCK_THRESHOLD = 10;

    public InventoryService() {
        this.inventoryDAO = new InventoryDAOImpl();
    }

    // ============================
    // CRUD
    // ============================

    public void addInventory(Inventory inventory) {
        validateInventory(inventory);

        Inventory existing = inventoryDAO.findByProductAndBatch(
                inventory.getProductId(), inventory.getBatchNumber());

        if (existing != null) {
            existing.setQuantityInStock(existing.getQuantityInStock() + inventory.getQuantityInStock());
            inventoryDAO.update(existing);
        } else {
            inventoryDAO.insert(inventory);
        }
    }

    public void updateInventory(Inventory inventory) {
        validateInventory(inventory);
        inventoryDAO.update(inventory);
    }

    public void deleteInventory(Integer inventoryId) {
        inventoryDAO.delete(inventoryId);
    }

    public Inventory getInventoryById(Integer inventoryId) {
        return inventoryDAO.findById(inventoryId);
    }

    public List<Inventory> getAllInventory() {
        return inventoryDAO.findAll();
    }

    // ============================
    // GESTION DU STOCK
    // ============================

    public boolean reserveStock(Integer inventoryId, Integer quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("La quantité doit être positive");
        }

        Inventory inventory = inventoryDAO.findById(inventoryId);
        if (inventory == null) {
            throw new IllegalArgumentException("Lot d'inventaire non trouvé");
        }

        if (inventory.getAvailableQuantity() < quantity) {
            throw new IllegalStateException("Stock insuffisant. Disponible: " +
                    inventory.getAvailableQuantity() + ", Demandé: " + quantity);
        }

        return inventoryDAO.reserveStock(inventoryId, quantity);
    }

    public boolean releaseStock(Integer inventoryId, Integer quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("La quantité doit être positive");
        }

        return inventoryDAO.releaseStock(inventoryId, quantity);
    }

    public boolean consumeStock(Integer inventoryId, Integer quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("La quantité doit être positive");
        }

        return inventoryDAO.consumeStock(inventoryId, quantity);
    }

    // ============================
    // RECHERCHES
    // ============================

    public List<Inventory> getInventoryByProduct(Integer productId) {
        return inventoryDAO.findByProductId(productId);
    }

    public List<Inventory> getExpiringSoon(int days) {
        return inventoryDAO.findExpiringSoon(days);
    }

    public List<Inventory> getExpiredProducts() {
        return inventoryDAO.findExpired();
    }

    public List<Inventory> getLowStock(int threshold) {
        return inventoryDAO.findLowStock(threshold);
    }

    public List<Inventory> getLowStock() {
        return inventoryDAO.findLowStock(DEFAULT_LOW_STOCK_THRESHOLD);
    }

    // ============================
    // NOUVELLES MÉTHODES POUR LE DASHBOARD
    // ============================

    /**
     * Calcule la valeur totale de l'inventaire
     */
    public double calculateTotalInventoryValue() {
        try {
            List<Inventory> allInventory = inventoryDAO.findAll();
            double totalValue = 0.0;

            for (Inventory inventory : allInventory) {
                // Calculer la valeur de chaque lot
                double lotValue = calculateLotValue(inventory);
                totalValue += lotValue;
            }

            return totalValue;

        } catch (Exception e) {
            System.err.println("Erreur calcul valeur inventaire: " + e.getMessage());
            return 0.0;
        }
    }

    /**
     * Calcule la valeur d'un lot spécifique
     */
    private double calculateLotValue(Inventory inventory) {
        if (inventory.getPurchasePrice() == null) {
            return 0.0;
        }

        // Valeur = prix d'achat × quantité en stock
        return inventory.getPurchasePrice() * inventory.getQuantityInStock();
    }

    /**
     * Compte le nombre de produits expirés
     */
    public int getExpiredProductsCount() {
        try {
            List<Inventory> expired = inventoryDAO.findExpired();
            return expired.size();
        } catch (Exception e) {
            System.err.println("Erreur comptage produits expirés: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Compte le nombre de produits qui expirent bientôt
     */
    public int getExpiringSoonCount(int days) {
        try {
            List<Inventory> expiringSoon = inventoryDAO.findExpiringSoon(days);
            return expiringSoon.size();
        } catch (Exception e) {
            System.err.println("Erreur comptage produits expirant bientôt: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Compte le nombre de produits en stock faible
     */
    public int getLowStockCount() {
        return getLowStockCount(DEFAULT_LOW_STOCK_THRESHOLD);
    }

    public int getLowStockCount(int threshold) {
        try {
            List<Inventory> lowStock = inventoryDAO.findLowStock(threshold);
            return lowStock.size();
        } catch (Exception e) {
            System.err.println("Erreur comptage stock faible: " + e.getMessage());
            return 0;
        }
    }

    // ============================
    // STATISTIQUES
    // ============================

    public int getTotalStockForProduct(Integer productId) {
        return inventoryDAO.getTotalStockQuantity(productId);
    }

    public int getAvailableStockForProduct(Integer productId) {
        return inventoryDAO.getAvailableStockQuantity(productId);
    }

    public int getReservedStockForProduct(Integer productId) {
        return inventoryDAO.getReservedStockQuantity(productId);
    }

    public boolean hasSufficientStock(Integer productId, Integer quantity) {
        return getAvailableStockForProduct(productId) >= quantity;
    }

    /**
     * Calcule la valeur du stock d'un produit spécifique
     */
    public double calculateProductStockValue(Integer productId) {
        try {
            List<Inventory> productInventory = inventoryDAO.findByProductId(productId);
            double productValue = 0.0;

            for (Inventory inventory : productInventory) {
                productValue += calculateLotValue(inventory);
            }

            return productValue;

        } catch (Exception e) {
            System.err.println("Erreur calcul valeur produit: " + e.getMessage());
            return 0.0;
        }
    }

    public List<Inventory> getInventoryWithPagination(int page, int pageSize, String search,
                                                      String category, String status, String stockStatus, String expiryStatus) {

        int offset = (page - 1) * pageSize;
        return inventoryDAO.getInventoryWithPagination(offset, pageSize, search,
                category, status, stockStatus, expiryStatus);
    }

    public long getTotalInventoryCount(String search, String category, String status,
                                       String stockStatus, String expiryStatus) {

        return inventoryDAO.getTotalInventoryCount(search, category, status,
                stockStatus, expiryStatus);
    }

    // ============================
    // MÉTHODES UTILITAIRES
    // ============================

    public Inventory findBestBatchForProduct(Integer productId, Integer quantity) {
        List<Inventory> batches = inventoryDAO.findByProductId(productId);

        // FIFO - les lots les plus anciens d'abord
        for (Inventory batch : batches) {
            if (batch.getAvailableQuantity() >= quantity && !batch.getIsExpired()) {
                return batch;
            }
        }

        // Chercher le lot avec le plus de stock
        Inventory bestBatch = null;
        int maxAvailable = 0;

        for (Inventory batch : batches) {
            int available = batch.getAvailableQuantity();
            if (available > maxAvailable && !batch.getIsExpired()) {
                maxAvailable = available;
                bestBatch = batch;
            }
        }

        return bestBatch;
    }

    /**
     * Met à jour le statut d'expiration des produits
     */
    public void updateExpiryStatus() {
        inventoryDAO.updateExpiryStatus();
    }

    /**
     * Vérifie si un lot a assez de stock disponible
     */
    public boolean isStockAvailable(Integer inventoryId, Integer quantity) {
        Inventory inventory = inventoryDAO.findById(inventoryId);
        if (inventory == null) return false;

        return inventory.getAvailableQuantity() >= quantity;
    }

    /**
     * Récupère le stock total de tous les produits
     */
    public int getTotalStockQuantity() {
        List<Inventory> allInventory = inventoryDAO.findAll();
        int totalQuantity = 0;

        for (Inventory inventory : allInventory) {
            totalQuantity += inventory.getQuantityInStock();
        }

        return totalQuantity;
    }

    // ============================
    // VALIDATION
    // ============================

    private void validateInventory(Inventory inventory) {
        if (inventory.getProductId() == null) {
            throw new IllegalArgumentException("Le produit est requis");
        }
        if (inventory.getBatchNumber() == null || inventory.getBatchNumber().trim().isEmpty()) {
            throw new IllegalArgumentException("Le numéro de lot est requis");
        }
        if (inventory.getExpiryDate() == null) {
            throw new IllegalArgumentException("La date d'expiration est requise");
        }
        if (inventory.getExpiryDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("La date d'expiration est déjà passée");
        }
        if (inventory.getQuantityInStock() < 0) {
            throw new IllegalArgumentException("La quantité ne peut pas être négative");
        }
    }
}