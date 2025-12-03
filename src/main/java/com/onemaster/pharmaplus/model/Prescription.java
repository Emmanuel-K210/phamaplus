package com.onemaster.pharmaplus.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Prescription {
    private Integer prescriptionId;
    private Integer customerId;
    private String customerName;
    private String doctorName;
    private String doctorLicense;
    private LocalDate prescriptionDate;
    private LocalDate validityDate;
    private String diagnosis;
    private String notes;
    private boolean isFilled;
    private LocalDate filledDate;
    private List<Medication> medications;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructeurs
    public Prescription() {
        this.medications = new ArrayList<>();
        this.prescriptionDate = LocalDate.now();
        this.validityDate = LocalDate.now().plusMonths(3); // 3 mois de validité par défaut
    }

    public Prescription(Integer customerId, String doctorName, LocalDate prescriptionDate) {
        this();
        this.customerId = customerId;
        this.doctorName = doctorName;
        this.prescriptionDate = prescriptionDate;
    }

    // Getters et Setters
    public Integer getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Integer prescriptionId) { this.prescriptionId = prescriptionId; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDoctorLicense() { return doctorLicense; }
    public void setDoctorLicense(String doctorLicense) { this.doctorLicense = doctorLicense; }

    public LocalDate getPrescriptionDate() { return prescriptionDate; }
    public void setPrescriptionDate(LocalDate prescriptionDate) { this.prescriptionDate = prescriptionDate; }

    public LocalDate getValidityDate() { return validityDate; }
    public void setValidityDate(LocalDate validityDate) { this.validityDate = validityDate; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public boolean isFilled() { return isFilled; }
    public void setFilled(boolean filled) { isFilled = filled; }

    public LocalDate getFilledDate() { return filledDate; }
    public void setFilledDate(LocalDate filledDate) { this.filledDate = filledDate; }

    public List<Medication> getMedications() { return medications; }
    public void setMedications(List<Medication> medications) { this.medications = medications; }
    public void addMedication(Medication medication) { this.medications.add(medication); }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Méthodes utilitaires
    public boolean isValid() {
        return !LocalDate.now().isAfter(validityDate);
    }

    public double getTotalAmount() {
        return medications.stream()
                .mapToDouble(m -> m.getPrice() * m.getQuantity())
                .sum();
    }
}

// Modèle pour les médicaments dans une ordonnance
