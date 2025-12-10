package com.onemaster.pharmaplus.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class MedicalReceipt {
    private Integer receiptId;
    private String receiptNumber;
    private LocalDateTime receiptDate;
    private String patientName;
    private String patientContact;
    private String serviceType;
    private Double amount;
    private String amountInWords;
    private String servedBy;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructeurs
    public MedicalReceipt() {
        this.receiptDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public MedicalReceipt(String receiptNumber, String patientName, String serviceType, Double amount) {
        this();
        this.receiptNumber = receiptNumber;
        this.patientName = patientName;
        this.serviceType = serviceType;
        this.amount = amount;
    }
    
    // Getters et Setters
    public Integer getReceiptId() {
        return receiptId;
    }
    
    public void setReceiptId(Integer receiptId) {
        this.receiptId = receiptId;
    }
    
    public String getReceiptNumber() {
        return receiptNumber;
    }
    
    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }
    
    public LocalDateTime getReceiptDate() {
        return receiptDate;
    }

    public Date getReceiptDateAsDate(){
    if (this.receiptDate != null) return Date.from(this.receiptDate.atZone(ZoneId.systemDefault()).toInstant());
    return null;
    }
    
    public void setReceiptDate(LocalDateTime receiptDate) {
        this.receiptDate = receiptDate;
    }
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    public String getPatientContact() {
        return patientContact;
    }
    
    public void setPatientContact(String patientContact) {
        this.patientContact = patientContact;
    }
    
    public String getServiceType() {
        return serviceType;
    }
    
    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }
    
    public Double getAmount() {
        return amount;
    }
    
    public void setAmount(Double amount) {
        this.amount = amount;
    }
    
    public String getAmountInWords() {
        return amountInWords;
    }
    
    public void setAmountInWords(String amountInWords) {
        this.amountInWords = amountInWords;
    }
    
    public String getServedBy() {
        return servedBy;
    }

    public void setServedBy(String servedBy) {
        this.servedBy = servedBy;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Date getCreatedAtAsDate(){
        if (this.receiptDate != null) return Date.from(this.receiptDate.atZone(ZoneId.systemDefault()).toInstant());
        return null;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }


    public Date getUpdatedAtAsDate(){
        if (this.receiptDate != null) return Date.from(this.receiptDate.atZone(ZoneId.systemDefault()).toInstant());
        return null;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Méthodes utilitaires
    public String getFormattedDate() {
        if (receiptDate != null) {
            return receiptDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "";
    }
    
    public String getFormattedAmount() {
        if (amount != null) {
            java.text.DecimalFormat df = new java.text.DecimalFormat("#,##0");
            return df.format(amount) + " F CFA";
        }
        return "0 F CFA";
    }
    
    // Builder pattern (optionnel mais utile)
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private MedicalReceipt receipt;
        
        public Builder() {
            receipt = new MedicalReceipt();
        }
        
        public Builder receiptNumber(String receiptNumber) {
            receipt.receiptNumber = receiptNumber;
            return this;
        }
        
        public Builder patientName(String patientName) {
            receipt.patientName = patientName;
            return this;
        }
        
        public Builder patientContact(String patientContact) {
            receipt.patientContact = patientContact;
            return this;
        }
        
        public Builder serviceType(String serviceType) {
            receipt.serviceType = serviceType;
            return this;
        }
        
        public Builder amount(Double amount) {
            receipt.amount = amount;
            return this;
        }
        
        public Builder amountInWords(String amountInWords) {
            receipt.amountInWords = amountInWords;
            return this;
        }
        
        public Builder servedBy(String servedBy) {
            receipt.servedBy = servedBy;
            return this;
        }
        
        public Builder notes(String notes) {
            receipt.notes = notes;
            return this;
        }
        
        public MedicalReceipt build() {
            return receipt;
        }
    }
    
    // equals, hashCode et toString
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        MedicalReceipt that = (MedicalReceipt) o;
        
        if (receiptId != null ? !receiptId.equals(that.receiptId) : that.receiptId != null) return false;
        return receiptNumber != null ? receiptNumber.equals(that.receiptNumber) : that.receiptNumber == null;
    }
    
    @Override
    public int hashCode() {
        int result = receiptId != null ? receiptId.hashCode() : 0;
        result = 31 * result + (receiptNumber != null ? receiptNumber.hashCode() : 0);
        return result;
    }
    
    @Override
    public String toString() {
        return "MedicalReceipt{" +
                "receiptId=" + receiptId +
                ", receiptNumber='" + receiptNumber + '\'' +
                ", patientName='" + patientName + '\'' +
                ", serviceType='" + serviceType + '\'' +
                ", amount=" + amount +
                '}';
    }
}