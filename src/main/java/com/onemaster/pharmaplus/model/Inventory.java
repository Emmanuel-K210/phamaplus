package com.onemaster.pharmapus.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Inventory {
    private Integer inventoryId;
    private Integer productId;
    private String batchNumber;
    private Integer supplierId;
    private Integer quantityInStock = 0;
    private Integer quantityReserved = 0;
    private LocalDate manufacturingDate;
    private LocalDate expiryDate;
    private Double purchasePrice;
    private LocalDate receivedDate = LocalDate.now();
    private String location;
    private Boolean isExpired;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Pour les jointures
    private String productName;
    private String supplierName;
    
    // Constructeurs
    public Inventory() {}
    
    public Inventory(Integer productId, String batchNumber, Integer quantityInStock, LocalDate expiryDate) {
        this.productId = productId;
        this.batchNumber = batchNumber;
        this.quantityInStock = quantityInStock;
        this.expiryDate = expiryDate;
    }
    
    // Getters/Setters
    public Integer getInventoryId() { return inventoryId; }
    public void setInventoryId(Integer inventoryId) { this.inventoryId = inventoryId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public String getBatchNumber() { return batchNumber; }
    public void setBatchNumber(String batchNumber) { this.batchNumber = batchNumber; }
    
    public Integer getSupplierId() { return supplierId; }
    public void setSupplierId(Integer supplierId) { this.supplierId = supplierId; }
    
    public Integer getQuantityInStock() { return quantityInStock; }
    public void setQuantityInStock(Integer quantityInStock) { this.quantityInStock = quantityInStock; }
    
    public Integer getQuantityReserved() { return quantityReserved; }
    public void setQuantityReserved(Integer quantityReserved) { this.quantityReserved = quantityReserved; }
    
    public LocalDate getManufacturingDate() { return manufacturingDate; }
    public void setManufacturingDate(LocalDate manufacturingDate) { this.manufacturingDate = manufacturingDate; }
    
    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
    
    public Double getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(Double purchasePrice) { this.purchasePrice = purchasePrice; }
    
    public LocalDate getReceivedDate() { return receivedDate; }
    public void setReceivedDate(LocalDate receivedDate) { this.receivedDate = receivedDate; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public Boolean getIsExpired() { return isExpired; }
    public void setIsExpired(Boolean isExpired) { this.isExpired = isExpired; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    // Méthode utilitaire
    public Integer getAvailableQuantity() {
        return quantityInStock - quantityReserved;
    }
    
    @Override
    public String toString() {
        return "Batch: " + batchNumber + " - Qty: " + quantityInStock;
    }
}