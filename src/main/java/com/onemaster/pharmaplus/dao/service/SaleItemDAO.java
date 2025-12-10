package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.SaleItem;

import java.time.LocalDate;
import java.util.List;

public interface SaleItemDAO {
    
    // CRUD operations
    Integer insert(SaleItem saleItem);
    void update(SaleItem saleItem);
    void delete(Integer saleItemId);
    SaleItem findById(Integer saleItemId);
    List<SaleItem> findAll();
    
    // Specialized queries
    List<SaleItem> findBySaleId(Integer saleId);
    List<SaleItem> findByProductId(Integer productId);
    List<SaleItem> findByInventoryId(Integer inventoryId);
    
    // Statistics and reports
    Integer getTotalQuantitySoldByProduct(Integer productId);
    Double getTotalRevenueByProduct(Integer productId);
    Integer getTotalItemsSoldForSale(Integer saleId);
    Double getTotalAmountForSale(Integer saleId);
    
    // Batch operations
    void insertBatch(List<SaleItem> saleItems);
    void deleteBySaleId(Integer saleId);
    
    // Inventory-related queries
    List<SaleItem> findByBatchNumber(String batchNumber);
    
    // Sales analysis
    List<Object[]> getProductSalesSummary(LocalDate start, LocalDate end);
    List<SaleItem> findTopSellingItems(int limit);
    
    // Check methods
    Boolean existsByProductId(Integer productId);
    Boolean existsByInventoryId(Integer inventoryId);
    
    // Get items with detailed product info
    List<SaleItem> findDetailedItemsBySaleId(Integer saleId);
}