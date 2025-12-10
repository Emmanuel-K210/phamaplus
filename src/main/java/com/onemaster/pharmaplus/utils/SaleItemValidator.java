package com.onemaster.pharmaplus.utils;

import com.onemaster.pharmaplus.model.SaleItem;

public class SaleItemValidator {
    
    public static void validate(SaleItem saleItem) throws IllegalArgumentException {
        if (saleItem == null) {
            throw new IllegalArgumentException("SaleItem cannot be null");
        }
        
        if (saleItem.getSaleId() == null) {
            throw new IllegalArgumentException("Sale ID is required");
        }
        
        if (saleItem.getProductId() == null) {
            throw new IllegalArgumentException("Product ID is required");
        }
        
        if (saleItem.getQuantity() == null || saleItem.getQuantity() <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }
        
        if (saleItem.getUnitPrice() == null || saleItem.getUnitPrice() < 0) {
            throw new IllegalArgumentException("Unit price must be positive or zero");
        }
        
        if (saleItem.getDiscount() != null && saleItem.getDiscount() < 0) {
            throw new IllegalArgumentException("Discount cannot be negative");
        }
        
        // Vérifier que le line_total est cohérent
        if (saleItem.getLineTotal() != null) {
            double calculatedTotal = (saleItem.getQuantity() * saleItem.getUnitPrice()) 
                                     - (saleItem.getDiscount() != null ? saleItem.getDiscount() : 0.0);
            
            if (Math.abs(saleItem.getLineTotal() - calculatedTotal) > 0.01) {
                throw new IllegalArgumentException("Line total calculation is inconsistent");
            }
        }
    }
}