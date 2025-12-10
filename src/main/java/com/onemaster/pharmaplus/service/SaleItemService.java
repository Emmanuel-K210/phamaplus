package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.service.SaleItemDAO;
import com.onemaster.pharmaplus.dao.impl.SaleItemDAOImpl;
import com.onemaster.pharmaplus.model.SaleItem;

import java.time.LocalDate;
import java.util.List;

public class SaleItemService {
    
    private final SaleItemDAO saleItemDAO;
    
    public SaleItemService() {
        this.saleItemDAO = new SaleItemDAOImpl();
    }
    

    // CRUD Operations
    public SaleItem createSaleItem(SaleItem saleItem) {
        if (saleItem == null) {
            throw new IllegalArgumentException("SaleItem cannot be null");
        }
        
        // Validation des données
        validateSaleItem(saleItem);
        
        // Calcul du line_total si nécessaire
        if (saleItem.getLineTotal() == null) {
            saleItem.calculateLineTotal();
        }
        
        Integer generatedId = saleItemDAO.insert(saleItem);
        if (generatedId != null) {
            return findById(generatedId);
        }
        return null;
    }
    
    public SaleItem updateSaleItem(SaleItem saleItem) {
        if (saleItem == null || saleItem.getSaleItemId() == null) {
            throw new IllegalArgumentException("SaleItem and its ID cannot be null");
        }
        
        validateSaleItem(saleItem);
        
        // S'assurer que line_total est à jour
        saleItem.calculateLineTotal();
        
        saleItemDAO.update(saleItem);
        return findById(saleItem.getSaleItemId());
    }
    
    public void deleteSaleItem(Integer saleItemId) {
        if (saleItemId == null) {
            throw new IllegalArgumentException("SaleItem ID cannot be null");
        }
        saleItemDAO.delete(saleItemId);
    }
    
    public SaleItem findById(Integer saleItemId) {
        if (saleItemId == null) {
            throw new IllegalArgumentException("SaleItem ID cannot be null");
        }
        return saleItemDAO.findById(saleItemId);
    }
    
    public List<SaleItem> findAll() {
        return saleItemDAO.findAll();
    }
    
    // Business Methods
    public List<SaleItem> findBySaleId(Integer saleId) {
        if (saleId == null) {
            throw new IllegalArgumentException("Sale ID cannot be null");
        }
        return saleItemDAO.findBySaleId(saleId);
    }
    
    public List<SaleItem> findByProductId(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        return saleItemDAO.findByProductId(productId);
    }
    
    public void addItemsToSale(Integer saleId, List<SaleItem> items) {
        if (saleId == null || items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Sale ID and items cannot be null/empty");
        }
        
        for (SaleItem item : items) {
            item.setSaleId(saleId);
            item.calculateLineTotal();
        }
        
        saleItemDAO.insertBatch(items);
    }
    
    public void removeAllItemsFromSale(Integer saleId) {
        if (saleId == null) {
            throw new IllegalArgumentException("Sale ID cannot be null");
        }
        saleItemDAO.deleteBySaleId(saleId);
    }
    
    // Statistics and Reports
    public Integer getTotalQuantitySoldForProduct(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        return saleItemDAO.getTotalQuantitySoldByProduct(productId);
    }
    
    public Double getTotalRevenueForProduct(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        return saleItemDAO.getTotalRevenueByProduct(productId);
    }
    
    public Double getTotalAmountForSale(Integer saleId) {
        if (saleId == null) {
            throw new IllegalArgumentException("Sale ID cannot be null");
        }
        return saleItemDAO.getTotalAmountForSale(saleId);
    }
    
    public Integer getTotalItemsSoldForSale(Integer saleId) {
        if (saleId == null) {
            throw new IllegalArgumentException("Sale ID cannot be null");
        }
        return saleItemDAO.getTotalItemsSoldForSale(saleId);
    }
    
    // Validation method
    private void validateSaleItem(SaleItem saleItem) {
        if (saleItem.getSaleId() == null) {
            throw new IllegalArgumentException("Sale ID is required");
        }
        
        if (saleItem.getProductId() == null) {
            throw new IllegalArgumentException("Product ID is required");
        }
        
        if (saleItem.getQuantity() == null || saleItem.getQuantity() <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }
        
        if (saleItem.getUnitPrice() == null || saleItem.getUnitPrice() < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative");
        }
        
        if (saleItem.getDiscount() != null && saleItem.getDiscount() < 0) {
            throw new IllegalArgumentException("Discount cannot be negative");
        }
    }
    
    // Sales Analysis
    public List<SaleItem> getTopSellingItems(int limit) {
        if (limit <= 0) {
            limit = 10; // Default limit
        }
        return saleItemDAO.findTopSellingItems(limit);
    }
    
    public List<Object[]> getProductSalesSummary(LocalDate start, LocalDate end) {
        if (start == null || end == null) {
            throw new IllegalArgumentException("Start and end dates cannot be null");
        }
        
        if (end.isBefore(start)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
        
        return saleItemDAO.getProductSalesSummary(start, end);
    }
    
    // Check methods
    public boolean isProductSold(Integer productId) {
        if (productId == null) {
            return false;
        }
        return saleItemDAO.existsByProductId(productId);
    }
    
    public boolean isInventoryItemSold(Integer inventoryId) {
        if (inventoryId == null) {
            return false;
        }
        return saleItemDAO.existsByInventoryId(inventoryId);
    }
    
    // Batch operations
    public void createBatchSaleItems(List<SaleItem> saleItems) {
        if (saleItems == null || saleItems.isEmpty()) {
            throw new IllegalArgumentException("Sale items list cannot be null or empty");
        }
        
        for (SaleItem item : saleItems) {
            validateSaleItem(item);
            item.calculateLineTotal();
        }
        
        saleItemDAO.insertBatch(saleItems);
    }
}