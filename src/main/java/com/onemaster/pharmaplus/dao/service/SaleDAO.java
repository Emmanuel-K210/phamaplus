package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleItem;

import java.time.LocalDate;
import java.util.List;

public interface SaleDAO {
    // CRUD Sales
    Integer insertSale(Sale sale);
    void updateSale(Sale sale);
    void deleteSale(Integer saleId);
    Sale findSaleById(Integer saleId);
    List<Sale> findAllSales();
    
    // CRUD Sale Items
    void insertSaleItem(SaleItem saleItem);
    List<SaleItem> findItemsBySaleId(Integer saleId);
    void deleteSaleItems(Integer saleId);
    
    // Recherches
    /**
     * Vérifie si une vente existe avec un ID donné et un statut spécifique
     * @param saleId ID de la vente
     * @param status Statut de paiement
     * @return true si la vente existe avec ce statut, false sinon
     */
    Boolean existsByIdAndStatus(Integer saleId, String status);

    /**
     * Met à jour le statut d'une vente
     * @param saleId ID de la vente
     * @param status Nouveau statut
     * @return true si mis à jour, false sinon
     */
    boolean updateStatus(Integer saleId, String status);

    Sale findSalesByIdAndStatus(Integer saleId, String status);
    List<Sale> findSalesByCustomer(Integer customerId);
    List<Sale> findSalesByDate(LocalDate date);
    List<Sale> findSalesByDateRange(LocalDate start, LocalDate end);
    List<Sale> findSalesByPaymentMethod(String paymentMethod);
    List<Sale> findSalesByPrescription(Integer prescriptionId);
    // Statistiques
    Double getTotalRevenue(LocalDate start, LocalDate end);
    Integer getTotalItemsSold(LocalDate start, LocalDate end);
    Integer getTotalTransactions(LocalDate start, LocalDate end);
    List<Object[]> getDailySales(LocalDate start, LocalDate end);
    List<Object[]> getTopSellingProducts(int limit);
    
    // Pour dashboard
    Double getTodayRevenue();
    Integer getTodayTransactions();
    List<Sale> getRecentSales(int limit);
}