package com.onemaster.pharmaplus.utils;

// Classe interne pour le résumé
public class SalesSummary {
    private Double revenue;
    private Integer transactions;
    private Integer itemsSold;
    private int uniqueCustomers;

    // Getters/Setters
    public Double getRevenue() {
        return revenue;
    }

    public void setRevenue(Double revenue) {
        this.revenue = revenue;
    }


    public int getUniqueCustomers() {   // <- obligatoire
        return uniqueCustomers;
    }

    public void setUniqueCustomers(int uniqueCustomers) {
        this.uniqueCustomers = uniqueCustomers;
    }

    public Integer getTransactions() {
        return transactions;
    }

    public void setTransactions(Integer transactions) {
        this.transactions = transactions;
    }

    public Integer getItemsSold() {
        return itemsSold;
    }

    public void setItemsSold(Integer itemsSold) {
        this.itemsSold = itemsSold;
    }
}