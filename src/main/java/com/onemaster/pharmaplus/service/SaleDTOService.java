package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.controller.SaleServlet;
import com.onemaster.pharmaplus.dao.impl.SaleDAOImpl;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.Customer;
import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleDTO;
import com.onemaster.pharmaplus.model.SaleItem;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

// Créer une classe SaleDTOService
public class SaleDTOService {
    private SaleDAO saleDAO;
    private CustomerService customerService;
    
    public SaleDTOService() {
        this.saleDAO = new SaleDAOImpl();
        this.customerService = new CustomerService();
    }
    
    public SaleDTO convertToDTO(Sale sale) {
        if (sale == null) return null;
        
        Customer customer = null;
        if (sale.getCustomerId() != null) {
            customer = customerService.getCustomerById(sale.getCustomerId());
        }
        
        // Récupérer les items pour calculer totalItems
        List<SaleItem> items = saleDAO.findItemsBySaleId(sale.getSaleId());
        int totalItems = 0;
        if (items != null) {
            totalItems = items.stream()
                .mapToInt(SaleItem::getQuantity)
                .sum();
        }
        
        return SaleDTO.builder()
            .saleId(sale.getSaleId())
            .customerName(customer != null ? customer.getFullName() : "Non renseigné")
            .customerPhone(customer != null ? customer.getPhone() : "")
            .totalItems(totalItems)
            .totalAmount(sale.getTotalAmount())
            .discountAmount(sale.getDiscountAmount())
            .paymentMethod(sale.getPaymentMethod())
            .paymentStatus(sale.getPaymentStatus())
            .saleDate(convertToDate(sale.getSaleDate()))
            .build();
    }
    
    private Date convertToDate(LocalDateTime localDateTime) {
        if (localDateTime == null) return new Date();
        return java.sql.Timestamp.valueOf(localDateTime);
    }
    
    public List<SaleDTO> convertToListDTO(List<Sale> sales) {
        return sales.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
}