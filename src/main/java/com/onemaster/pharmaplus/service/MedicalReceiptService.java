package com.onemaster.pharmaplus.service;


import com.onemaster.pharmaplus.dao.impl.MedicalReceiptDAOImpl;
import com.onemaster.pharmaplus.dao.service.MedicalReceiptDAO;
import com.onemaster.pharmaplus.model.MedicalReceipt;
import java.time.LocalDateTime;
import java.util.List;

public class MedicalReceiptService {
    
    private MedicalReceiptDAO receiptDAO;
    
    public MedicalReceiptService() {
        this.receiptDAO = new MedicalReceiptDAOImpl();
    }
    
    // Toutes les méthodes restent identiques
    public Integer saveReceipt(MedicalReceipt receipt) {
        return receiptDAO.save(receipt);
    }
    
    public MedicalReceipt getReceiptById(Integer id) {
        return receiptDAO.findById(id);
    }
    
    public List<MedicalReceipt> getAllReceipts() {
        return receiptDAO.findAll();
    }
    
    public List<MedicalReceipt> getReceiptsByDateRange(LocalDateTime start, LocalDateTime end) {
        return receiptDAO.findByDateRange(start, end);
    }
    
    public boolean updateReceipt(MedicalReceipt receipt) {
        return receiptDAO.update(receipt);
    }
    
    public boolean deleteReceipt(Integer id) {
        return receiptDAO.delete(id);
    }
    
    public String generateReceiptNumber() {
        return receiptDAO.generateReceiptNumber();
    }
    
    public double getTotalRevenue(LocalDateTime start, LocalDateTime end) {
        // Si votre DAO a la méthode getTotalRevenueByDate, utilisez-la
        if (receiptDAO instanceof MedicalReceiptDAOImpl) {
            return ((MedicalReceiptDAOImpl) receiptDAO).getTotalRevenueByDate(start, end);
        }
        
        // Sinon, calculez manuellement
        List<MedicalReceipt> receipts = receiptDAO.findByDateRange(start, end);
        return receipts.stream()
                .mapToDouble(MedicalReceipt::getAmount)
                .sum();
    }
    
    public long getReceiptCount(LocalDateTime start, LocalDateTime end) {
        return receiptDAO.findByDateRange(start, end).size();
    }
}