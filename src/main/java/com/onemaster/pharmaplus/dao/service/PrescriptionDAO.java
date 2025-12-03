package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Prescription;
import java.time.LocalDate;
import java.util.List;

public interface PrescriptionDAO {
    void insert(Prescription prescription);
    void update(Prescription prescription);
    void delete(Integer prescriptionId);
    Prescription findById(Integer prescriptionId);
    List<Prescription> findAll();
    List<Prescription> findByCustomerId(Integer customerId);
    List<Prescription> findByDateRange(LocalDate startDate, LocalDate endDate);
    List<Prescription> findByDoctor(String doctorName);
    List<Prescription> findPendingPrescriptions();
    List<Prescription> findExpiredPrescriptions();
    int countByStatus(boolean filled);
    List<Prescription> search(String searchTerm);
}