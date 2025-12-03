package com.onemaster.pharmaplus.service;


import com.onemaster.pharmaplus.dao.impl.ProductDAOImpl;
import com.onemaster.pharmaplus.dao.service.ProductDAO;
import com.onemaster.pharmaplus.model.Product;
import java.util.List;

public class ProductService {
    
    private final ProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAOImpl();
    }
    
    // Méthodes de base
    public void addProduct(Product product) {
        validateProduct(product);
        productDAO.insert(product);
    }
    
    public void updateProduct(Product product) {
        validateProduct(product);
        productDAO.update(product);
    }
    
    public void deleteProduct(Integer productId) {
        productDAO.delete(productId);
    }
    
    public Product getProductById(Integer productId) {
        return productDAO.findById(productId);
    }
    
    public Product getProductByBarcode(String barcode) {
        return productDAO.findByBarcode(barcode);
    }
    
    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }
    
    // Recherches
    public List<Product> searchProductsByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return getAllProducts();
        }
        return productDAO.findByName(name.trim());
    }
    
    public List<Product> getProductsByCategory(Integer categoryId) {
        return productDAO.findByCategory(categoryId);
    }
    
    public List<Product> getLowStockProducts() {
        return productDAO.findLowStockProducts();
    }
    
    public List<Product> getPrescriptionProducts() {
        return productDAO.findRequiringPrescription();
    }
    
    // Validation
    private void validateProduct(Product product) {
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du produit est requis");
        }
        if (product.getSellingPrice() == null || product.getSellingPrice() <= 0) {
            throw new IllegalArgumentException("Le prix de vente doit être positif");
        }
        if (product.getUnitPrice() != null && product.getUnitPrice() > product.getSellingPrice()) {
            throw new IllegalArgumentException("Le prix d'achat ne peut pas être supérieur au prix de vente");
        }
    }
    
    // Statistiques
    public int getTotalProducts() {
        return productDAO.countAll();
    }
    
    public int getProductsCountByCategory(Integer categoryId) {
        return productDAO.countByCategory(categoryId);
    }
    
    // Utilitaires
    public boolean isProductAvailable(Integer productId) {
        Product product = productDAO.findById(productId);
        return product != null && product.getIsActive();
    }

    private Double mapToDouble(Product product) {
        return product.getUnitPrice();
    }
}