package com.onemaster.pharmaplus.model;

public class SaleItem {
    private Integer saleItemId;
    private Integer saleId;
    private Integer productId;
    private Integer inventoryId;
    private Integer quantity;
    private Double unitPrice;
    private Double discount = 0.0;
    private Double lineTotal;
    
    // Pour jointures
    private String productName;
    private String batchNumber;
    
    // Constructeurs
    public SaleItem() {}
    
    public SaleItem(Integer saleId, Integer productId, Integer quantity, Double unitPrice) {
        this.saleId = saleId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = quantity * unitPrice;
    }
    
    // Getters/Setters
    public Integer getSaleItemId() { return saleItemId; }
    public void setSaleItemId(Integer saleItemId) { this.saleItemId = saleItemId; }
    
    public Integer getSaleId() { return saleId; }
    public void setSaleId(Integer saleId) { this.saleId = saleId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public Integer getInventoryId() { return inventoryId; }
    public void setInventoryId(Integer inventoryId) { this.inventoryId = inventoryId; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { 
        this.quantity = quantity;
        calculateLineTotal();
    }
    
    public Double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Double unitPrice) { 
        this.unitPrice = unitPrice;
        calculateLineTotal();
    }
    
    public Double getDiscount() { return discount; }
    public void setDiscount(Double discount) { 
        this.discount = discount;
        calculateLineTotal();
    }
    
    public Double getLineTotal() { return lineTotal; }
    public void setLineTotal(Double lineTotal) { this.lineTotal = lineTotal; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getBatchNumber() { return batchNumber; }
    public void setBatchNumber(String batchNumber) { this.batchNumber = batchNumber; }
    
    // Méthodes
    private void calculateLineTotal() {
        if (quantity != null && unitPrice != null) {
            this.lineTotal = (quantity * unitPrice) - (discount != null ? discount : 0.0);
        }
    }
}