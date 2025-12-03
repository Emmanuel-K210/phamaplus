package com.onemaster.pharmaplus.model;

public class PrescriptionItem {
    private Integer prescriptionItemId;
    private Integer prescriptionId;
    private Integer productId;
    private Integer quantityPrescribed;
    private Integer quantityDispensed = 0;
    private String dosageInstructions;
    
    // Pour jointures
    private String productName;
    
    // Constructeurs
    public PrescriptionItem() {}
    
    public PrescriptionItem(Integer prescriptionId, Integer productId, Integer quantityPrescribed) {
        this.prescriptionId = prescriptionId;
        this.productId = productId;
        this.quantityPrescribed = quantityPrescribed;
    }
    
    // Getters/Setters
    public Integer getPrescriptionItemId() { return prescriptionItemId; }
    public void setPrescriptionItemId(Integer prescriptionItemId) { this.prescriptionItemId = prescriptionItemId; }
    
    public Integer getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Integer prescriptionId) { this.prescriptionId = prescriptionId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public Integer getQuantityPrescribed() { return quantityPrescribed; }
    public void setQuantityPrescribed(Integer quantityPrescribed) { this.quantityPrescribed = quantityPrescribed; }
    
    public Integer getQuantityDispensed() { return quantityDispensed; }
    public void setQuantityDispensed(Integer quantityDispensed) { this.quantityDispensed = quantityDispensed; }
    
    public String getDosageInstructions() { return dosageInstructions; }
    public void setDosageInstructions(String dosageInstructions) { this.dosageInstructions = dosageInstructions; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    // Méthode utilitaire
    public Integer getRemainingQuantity() {
        return quantityPrescribed - quantityDispensed;
    }
    
    public boolean isFullyDispensed() {
        return quantityDispensed >= quantityPrescribed;
    }
}