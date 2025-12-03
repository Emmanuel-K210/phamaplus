package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Inventory;

import java.time.LocalDate;
import java.util.List;

public interface InventoryDAO {
    // CRUD
    void insert(Inventory inventory);
    void update(Inventory inventory);
    void delete(Integer inventoryId);
    Inventory findById(Integer inventoryId);
    List<Inventory> findAll();
    
    // Recherches
    List<Inventory> findByProductId(Integer productId);
    List<Inventory> findByBatchNumber(String batchNumber);
    List<Inventory> findBySupplierId(Integer supplierId);
    Inventory findByProductAndBatch(Integer productId, String batchNumber);
    
    // Gestion du stock
    boolean reserveStock(Integer inventoryId, Integer quantity);
    boolean releaseStock(Integer inventoryId, Integer quantity);
    boolean consumeStock(Integer inventoryId, Integer quantity);
    
    // Recherches avancées
    List<Inventory> findExpiringSoon(int days);
    List<Inventory> findExpired();
    List<Inventory> findLowStock(int threshold);
    List<Inventory> findByLocation(String location);
    List<Inventory> findByExpiryDateRange(LocalDate start, LocalDate end);
    
    // Statistiques
    int getTotalStockQuantity(Integer productId);
    int getAvailableStockQuantity(Integer productId);
    int getReservedStockQuantity(Integer productId);
    
    // Batch operations
    void updateExpiryStatus();
}