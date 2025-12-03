package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Customer;

import java.util.List;

public interface CustomerDAO {
    void insert(Customer customer);
    void update(Customer customer);
    void delete(Integer customerId);
    Customer findById(Integer customerId);
    List<Customer> findAll();
    List<Customer> findByNameOrPhone(String searchTerm);
    Customer findByEmail(String email);
    Customer findByPhone(String phone);
}