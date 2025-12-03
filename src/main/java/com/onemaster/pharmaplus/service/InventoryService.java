package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.InventoryDAOImpl;
import com.onemaster.pharmaplus.dao.service.InventoryDAO;
import com.onemaster.pharmaplus.model.Inventory;

import java.time.LocalDate;
import java.util.List;

public class InventoryService {
    
    private final InventoryDAO inventoryDAO;
    
    public InventoryService() {
        this.inventoryDAO = new InventoryDAOImpl();
    }
    
    // CRUD
    public void addInventory(Inventory inventory) {
        validateInventory(inventory);
        
        // Vérifier si le lot existe déjà
        Inventory existing = inventoryDAO.findByProductAndBatch(
            inventory.getProductId(), inventory.getBatchNumber());
        
        if (existing != null) {
            // Mettre à jour la quantité existante
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
    
    // Gestion du stock
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
    
    public boolean consumeStock(Integer inventoryId, Integer quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("La quantité doit être positive");
        }
        
        return inventoryDAO.consumeStock(inventoryId, quantity);
    }
    
    // Recherches
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
    
    // Statistiques
    public int getTotalStockForProduct(Integer productId) {
        return inventoryDAO.getTotalStockQuantity(productId);
    }
    
    public int getAvailableStockForProduct(Integer productId) {
        return inventoryDAO.getAvailableStockQuantity(productId);
    }
    
    public boolean hasSufficientStock(Integer productId, Integer quantity) {
        return getAvailableStockForProduct(productId) >= quantity;
    }
    
    // Validation
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
    
    // Méthode utilitaire pour vente
    public Inventory findBestBatchForProduct(Integer productId, Integer quantity) {
        List<Inventory> batches = inventoryDAO.findByProductId(productId);
        
        // Priorité: FIFO (First In First Out) - les lots les plus anciens d'abord
        for (Inventory batch : batches) {
            if (batch.getAvailableQuantity() >= quantity && !batch.getIsExpired()) {
                return batch;
            }
        }
        
        // Si aucun lot n'a assez de stock, chercher le lot avec le plus de stock
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
}