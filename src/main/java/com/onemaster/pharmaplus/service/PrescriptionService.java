package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.PrescriptionDAOImpl;
import com.onemaster.pharmaplus.model.Prescription;
import java.time.LocalDate;
import java.util.List;

public class PrescriptionService {
    
    private final PrescriptionDAOImpl prescriptionDAO;
    
    public PrescriptionService() {
        this.prescriptionDAO = new PrescriptionDAOImpl();
    }
    
    // Méthodes CRUD
    public void savePrescription(Prescription prescription) {
        validatePrescription(prescription);
        
        if (prescription.getPrescriptionId() == null) {
            prescriptionDAO.insert(prescription);
        } else {
            prescriptionDAO.update(prescription);
        }
    }
    
    public void deletePrescription(Integer prescriptionId) {
        prescriptionDAO.delete(prescriptionId);
    }
    
    public Prescription getPrescriptionById(Integer prescriptionId) {
        return prescriptionDAO.findById(prescriptionId);
    }
    
    public List<Prescription> getAllPrescriptions() {
        return prescriptionDAO.findAll();
    }
    
    public List<Prescription> getPrescriptionsByCustomer(Integer customerId) {
        return prescriptionDAO.findByCustomerId(customerId);
    }
    
    public List<Prescription> getPrescriptionsByDateRange(LocalDate startDate, LocalDate endDate) {
        return prescriptionDAO.findByDateRange(startDate, endDate);
    }
    
    public List<Prescription> getPrescriptionsByDoctor(String doctorName) {
        return prescriptionDAO.findByDoctor(doctorName);
    }
    
    // Méthodes spécifiques
    public List<Prescription> getPendingPrescriptions() {
        return prescriptionDAO.findPendingPrescriptions();
    }
    
    public List<Prescription> getExpiredPrescriptions() {
        return prescriptionDAO.findExpiredPrescriptions();
    }
    
    public List<Prescription> getTodayPrescriptions() {
        return prescriptionDAO.findTodayPrescriptions();
    }
    
    public List<Prescription> getPrescriptionsToExpire(int daysBefore) {
        return prescriptionDAO.findPrescriptionsToExpire(daysBefore);
    }
    
    public List<Prescription> searchPrescriptions(String searchTerm) {
        return prescriptionDAO.search(searchTerm);
    }
    
    // Statistiques
    public int getTotalPrescriptions() {
        return prescriptionDAO.countAllPrescriptions();
    }
    
    public int getFilledPrescriptionsCount() {
        return prescriptionDAO.countByStatus(true);
    }
    
    public int getPendingPrescriptionsCount() {
        return prescriptionDAO.countByStatus(false);
    }
    
    // Validation
    private void validatePrescription(Prescription prescription) {
        if (prescription.getCustomerId() == null) {
            throw new IllegalArgumentException("Le client est requis");
        }
        if (prescription.getDoctorName() == null || prescription.getDoctorName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du médecin est requis");
        }
        if (prescription.getPrescriptionDate() == null) {
            throw new IllegalArgumentException("La date de prescription est requise");
        }
        if (prescription.getValidityDate() != null && 
            prescription.getValidityDate().isBefore(prescription.getPrescriptionDate())) {
            throw new IllegalArgumentException("La date de validité ne peut pas être antérieure à la date de prescription");
        }
        if (prescription.getMedications() == null || prescription.getMedications().isEmpty()) {
            throw new IllegalArgumentException("Au moins un médicament est requis");
        }
    }
    
    // Méthode pour honorer une ordonnance
    public void fillPrescription(Integer prescriptionId) {
        Prescription prescription = getPrescriptionById(prescriptionId);
        if (prescription != null) {
            prescription.setFilled(true);
            prescription.setFilledDate(LocalDate.now());
            prescriptionDAO.update(prescription);
        } else {
            throw new RuntimeException("Ordonnance non trouvée avec l'ID: " + prescriptionId);
        }
    }
}