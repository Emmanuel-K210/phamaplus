package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.SupplierDAO;
import com.onemaster.pharmaplus.model.Supplier;
import java.util.List;

public class SupplierService {
    
    private final SupplierDAO supplierDAO;
    
    public SupplierService() {
        this.supplierDAO = new SupplierDAO();
    }
    
    public void addSupplier(Supplier supplier) {
        validateSupplier(supplier);
        supplierDAO.insert(supplier);
    }
    
    public Supplier getSupplierById(Integer supplierId) {
        return supplierDAO.findById(supplierId);
    }
    
    public List<Supplier> getAllSuppliers() {
        return supplierDAO.findAll();
    }
    
    public List<Supplier> getActiveSuppliers() {
        return supplierDAO.findActiveSuppliers();
    }
    
    public List<Supplier> searchSuppliers(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return supplierDAO.findAll();
        }
        return supplierDAO.searchByNameOrContact(searchTerm);
    }
    
    public void updateSupplier(Supplier supplier) {
        validateSupplier(supplier);
        supplierDAO.update(supplier);
    }
    
    public void deleteSupplier(Integer supplierId) {
        // Vérifier si le fournisseur a des produits en stock
        boolean hasProducts = supplierDAO.hasProducts(supplierId);
        if (hasProducts) {
            throw new IllegalArgumentException("Impossible de supprimer un fournisseur avec des produits en stock");
        }
        
        supplierDAO.delete(supplierId);
    }
    
    public void toggleSupplierStatus(Integer supplierId, boolean active) {
        supplierDAO.updateStatus(supplierId, active);
    }
    
    public int getSupplierProductCount(Integer supplierId) {
        return supplierDAO.getProductCount(supplierId);
    }
    
    private void validateSupplier(Supplier supplier) {
        if (supplier.getSupplierName() == null || supplier.getSupplierName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du fournisseur est requis");
        }
        if (supplier.getPhone() == null || supplier.getPhone().trim().isEmpty()) {
            throw new IllegalArgumentException("Le téléphone est requis");
        }
        
        // Validation du téléphone
        String phone = supplier.getPhone().replaceAll("[^0-9]", "");
        if (phone.length() < 10) {
            throw new IllegalArgumentException("Le téléphone doit contenir au moins 10 chiffres");
        }
        
        // Validation de l'email si fourni
        if (supplier.getEmail() != null && !supplier.getEmail().trim().isEmpty()) {
            String email = supplier.getEmail().trim();
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Format d'email invalide");
            }
        }
        
        // Validation du niveau de réapprovisionnement
        if (supplier.getReorderLevel() != null && supplier.getReorderLevel() < 1) {
            throw new IllegalArgumentException("Le niveau de réapprovisionnement doit être supérieur à 0");
        }
    }
}