package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.MedicalReceipt;
import java.time.LocalDateTime;
import java.util.List;

public interface MedicalReceiptDAO {
    Integer save(MedicalReceipt receipt);
    MedicalReceipt findById(Integer id);
    List<MedicalReceipt> findAll();
    List<MedicalReceipt> findByDateRange(LocalDateTime start, LocalDateTime end);
    boolean update(MedicalReceipt receipt);
    boolean delete(Integer id);
    String generateReceiptNumber();
    // Méthodes supplémentaires pour PostgreSQL
    List<String> getServiceTypes();
    Double getTotalRevenueByDate(LocalDateTime start, LocalDateTime end);
}