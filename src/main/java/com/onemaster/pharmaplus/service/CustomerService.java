package com.onemaster.pharmaplus.service;

import com.onemaster.pharmaplus.dao.impl.CustomerDAOImpl;
import com.onemaster.pharmaplus.dao.impl.CustomerDAOImpl.CustomerStats;
import com.onemaster.pharmaplus.model.Customer;
import java.util.List;

public class CustomerService {
    
    private final CustomerDAOImpl customerDAO;
    
    public CustomerService() {
        this.customerDAO = new CustomerDAOImpl();
    }
    
    // Méthodes CRUD basiques
    public void addCustomer(Customer customer) {
        validateCustomer(customer);
        customerDAO.insert(customer);
    }
    
    public Customer getCustomerById(Integer customerId) {
        return customerDAO.findById(customerId);
    }
    
    public List<Customer> searchCustomers(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return customerDAO.findAll();
        }
        return customerDAO.findByNameOrPhone(searchTerm);
    }
    
    public List<Customer> getAllCustomers() {
        return customerDAO.findAll();
    }
    
    public void deleteCustomer(int customerId) {
        customerDAO.delete(customerId);
    }
    
    public void updateCustomer(Customer customer) {
        validateCustomer(customer);
        customerDAO.update(customer);
    }
    
    // Pour l'auto-complétion dans les ventes
    public List<Customer> findCustomersForAutocomplete(String query) {
        return customerDAO.findByNameOrPhone(query);
    }
    
    // Méthodes spécifiques
    public List<Customer> getCustomersWithEmail() {
        return customerDAO.getCustomersWithEmail();
    }
    
    public List<Customer> getCustomersWithAllergies() {
        return customerDAO.findCustomersWithAllergies();
    }
    
    public List<Customer> getCustomersWithPrescriptions() {
        return customerDAO.findCustomersWithPrescriptions();
    }
    
    public List<Customer> getCustomersByBirthdayMonth(int month) {
        if (month < 1 || month > 12) {
            throw new IllegalArgumentException("Le mois doit être entre 1 et 12");
        }
        return customerDAO.findCustomersByBirthdayMonth(month);
    }
    
    public Customer getCustomerByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        return customerDAO.findByEmail(email);
    }
    
    public Customer getCustomerByPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return null;
        }
        return customerDAO.findByPhone(phone);
    }
    
    public boolean customerExists(String email, String phone) {
        return customerDAO.customerExists(email, phone);
    }
    
    public Customer getLatestCustomer() {
        return customerDAO.getLatestCustomer();
    }
    
    public int countAllCustomers() {
        return customerDAO.countAllCustomers();
    }
    
    public CustomerStats getCustomerStats() {
        return customerDAO.getCustomerStats();
    }
    
    // Validation
    private void validateCustomer(Customer customer) {
        if (customer.getFirstName() == null || customer.getFirstName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom est requis");
        }
        if (customer.getLastName() == null || customer.getLastName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom est requis");
        }
        if (customer.getPhone() == null || customer.getPhone().trim().isEmpty()) {
            throw new IllegalArgumentException("Le téléphone est requis");
        }
        
        // Vérifier la longueur du téléphone
        String phone = customer.getPhone().replaceAll("\\s+", "");
        if (phone.length() < 8 || phone.length() > 15) {
            throw new IllegalArgumentException("Le numéro de téléphone doit contenir entre 8 et 15 chiffres");
        }
        
        // Vérifier l'email si fourni
        if (customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
            String email = customer.getEmail().trim();
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Format d'email invalide");
            }
        }
    }
}