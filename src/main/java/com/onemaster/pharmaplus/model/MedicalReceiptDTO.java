package com.onemaster.pharmaplus.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class MedicalReceiptDTO {
    private Integer receiptId;
    private String receiptNumber;
    private String receiptDate;
    private String patientName;
    private String patientContact;
    private String serviceType;
    private String formattedAmount;
    private Double amount;
    private String amountInWords;
    private String servedBy;
    private String notes;
    
    // Constructeur à partir de l'entité
    public MedicalReceiptDTO(MedicalReceipt receipt) {
        this.receiptId = receipt.getReceiptId();
        this.receiptNumber = receipt.getReceiptNumber();
        this.receiptDate = receipt.getFormattedDate();
        this.patientName = receipt.getPatientName();
        this.patientContact = receipt.getPatientContact();
        this.serviceType = receipt.getServiceType();
        this.formattedAmount = receipt.getFormattedAmount();
        this.amount = receipt.getAmount();
        this.amountInWords = receipt.getAmountInWords();
        this.servedBy = receipt.getServedBy();
        this.notes = receipt.getNotes();
    }

    // Getters et Setters
    public Integer getReceiptId() { return receiptId; }
    public void setReceiptId(Integer receiptId) { this.receiptId = receiptId; }
    
    public String getReceiptNumber() { return receiptNumber; }
    public void setReceiptNumber(String receiptNumber) { this.receiptNumber = receiptNumber; }
    
    public String getReceiptDate() { return receiptDate; }
    public void setReceiptDate(String receiptDate) { this.receiptDate = receiptDate; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    
    public String getPatientContact() { return patientContact; }
    public void setPatientContact(String patientContact) { this.patientContact = patientContact; }
    
    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }
    
    public String getFormattedAmount() { return formattedAmount; }
    public void setFormattedAmount(String formattedAmount) { this.formattedAmount = formattedAmount; }
    
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    
    public String getAmountInWords() { return amountInWords; }
    public void setAmountInWords(String amountInWords) { this.amountInWords = amountInWords; }
    
    public String getServedBy() { return servedBy; }
    public void setServedBy(String servedBy) { this.servedBy = servedBy; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    // Builder pattern
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private MedicalReceiptDTO dto;
        
        public Builder() {
            dto = new MedicalReceiptDTO();
        }
        
        public Builder receiptId(Integer receiptId) {
            dto.receiptId = receiptId;
            return this;
        }
        
        public Builder receiptNumber(String receiptNumber) {
            dto.receiptNumber = receiptNumber;
            return this;
        }
        
        public Builder receiptDate(LocalDateTime receiptDate) {
            if (receiptDate != null) {
                dto.receiptDate = receiptDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            }
            return this;
        }
        
        public Builder patientName(String patientName) {
            dto.patientName = patientName;
            return this;
        }
        
        public Builder serviceType(String serviceType) {
            dto.serviceType = serviceType;
            return this;
        }
        
        public Builder amount(Double amount) {
            dto.amount = amount;
            if (amount != null) {
                java.text.DecimalFormat df = new java.text.DecimalFormat("#,##0");
                dto.formattedAmount = df.format(amount) + " F CFA";
            }
            return this;
        }
        
        public MedicalReceiptDTO build() {
            return dto;
        }
    }
    
    // Pour les cas où on n'a pas d'entité
    private MedicalReceiptDTO() {}
}