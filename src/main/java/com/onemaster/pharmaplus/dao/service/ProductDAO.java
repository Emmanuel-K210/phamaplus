package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Product;

import java.util.List;

public interface ProductDAO {
    // CRUD
    void insert(Product product);
    void update(Product product);
    void delete(Integer productId);
    Product findById(Integer productId);
    Product findByBarcode(String barcode);
    List<Product> findAll();
    
    // Recherches spécifiques
    List<Product> findByName(String name);
    List<Product> findByCategory(Integer categoryId);
    List<Product> findActiveProducts();
    List<Product> findLowStockProducts();
    List<Product> findRequiringPrescription();
    
    // Statistiques
    int countAll();
    int countByCategory(Integer categoryId);
    
    // Mise à jour du stock (via trigger ou manuel)
    void updateStock(Integer productId, Integer quantityChange);

    List<Product> getProductsWithPagination(int offset, int limit, String search, String category, String status);
    long getTotalProductsCount(String search, String category, String status);
    long getActiveProductsCount();
    long getPrescriptionProductsCount();
    double getTotalInventoryValue();

    // Méthodes utilitaires supplémentaires
    List<Product> getProductsByManufacturer(String manufacturer);
    List<String> getAllManufacturers();
    List<String> getAllDosageForms();
}