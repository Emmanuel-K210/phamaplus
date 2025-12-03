package com.onemaster.pharmaplus.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class PurchaseOrder {
    private Integer poId;
    private Integer supplierId;
    private LocalDate orderDate;
    private LocalDate expectedDeliveryDate;
    private LocalDate actualDeliveryDate;
    private String status; // pending, approved, received, cancelled
    private Double totalAmount = 0.0;
    private String notes;
    private String createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Pour jointures
    private String supplierName;
    
    // Constructeurs
    public PurchaseOrder() {
        this.orderDate = LocalDate.now();
        this.status = "pending";
    }
    
    public PurchaseOrder(Integer supplierId) {
        this();
        this.supplierId = supplierId;
    }
    
    // Getters/Setters
    public Integer getPoId() { return poId; }
    public void setPoId(Integer poId) { this.poId = poId; }
    
    public Integer getSupplierId() { return supplierId; }
    public void setSupplierId(Integer supplierId) { this.supplierId = supplierId; }
    
    public LocalDate getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDate orderDate) { this.orderDate = orderDate; }
    
    public LocalDate getExpectedDeliveryDate() { return expectedDeliveryDate; }
    public void setExpectedDeliveryDate(LocalDate expectedDeliveryDate) { this.expectedDeliveryDate = expectedDeliveryDate; }
    
    public LocalDate getActualDeliveryDate() { return actualDeliveryDate; }
    public void setActualDeliveryDate(LocalDate actualDeliveryDate) { this.actualDeliveryDate = actualDeliveryDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    @Override
    public String toString() {
        return "PO #" + poId + " - " + supplierName + " - " + totalAmount + "€";
    }
}