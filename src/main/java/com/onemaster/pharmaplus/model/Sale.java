package com.onemaster.pharmaplus.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Sale {
    private Integer saleId;
    private Integer customerId;
    private Integer prescriptionId;
    private LocalDateTime saleDate;
    private Double subtotal = 0.0;
    private Double discountAmount = 0.0;
    private Double taxAmount = 0.0;
    private Double totalAmount = 0.0;
    private String paymentMethod; // cash, card, insurance, mobile_payment
    private String paymentStatus; // paid, pending, refunded
    private String servedBy;
    private String notes;
    private Integer totalItems;
    private List<SaleItem> items = new ArrayList<>();

    // Pour jointures
    private String customerName;
    
    // Constructeurs
    public Sale() {
        this.saleDate = LocalDateTime.now();
        this.paymentStatus = "paid";
    }
    
    public Sale(Integer customerId, String paymentMethod) {
        this();
        this.customerId = customerId;
        this.paymentMethod = paymentMethod;
    }
    
    // Getters/Setters
    public Integer getSaleId() { return saleId; }
    public void setSaleId(Integer saleId) { this.saleId = saleId; }
    public Integer getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Integer totalItems) {
        this.totalItems = totalItems;
    }

    // getters/setters pour items
    public List<SaleItem> getItems() {
        return items;
    }

    public void setItems(List<SaleItem> items) {
        this.items = items;
        this.totalItems = (items == null) ? 0 : items.size();
    }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    
    public Integer getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Integer prescriptionId) { this.prescriptionId = prescriptionId; }
    
    public LocalDateTime getSaleDate() { return saleDate; }
    public void setSaleDate(LocalDateTime saleDate) { this.saleDate = saleDate; }
    
    public Double getSubtotal() { return subtotal; }
    public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }
    
    public Double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(Double discountAmount) { this.discountAmount = discountAmount; }
    
    public Double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(Double taxAmount) { this.taxAmount = taxAmount; }
    
    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getServedBy() { return servedBy; }
    public void setServedBy(String servedBy) { this.servedBy = servedBy; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getReference() {
        if (saleId != null) {
            return "SALE-" + saleId;
        }
        return null;
    }
    @Override
    public String toString() {
        return "Sale #" + saleId + " - " + totalAmount + "CFA";
    }
}