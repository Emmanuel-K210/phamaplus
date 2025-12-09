package com.onemaster.pharmaplus.model;

import java.util.Date;

/**
 * DTO pour l'affichage des ventes dans la liste
 * Simplifie les données transmises à la vue JSP
 */
public class SaleDTO {
    private Integer saleId;
    private String customerName;
    private String customerPhone;
    private Integer totalItems;
    private Double totalAmount;
    private Double discountAmount;
    private String paymentMethod;
    private String paymentStatus;
    private Date saleDate;

    // Constructeur par défaut
    public SaleDTO() {}

    // Constructeur avec Builder
    private SaleDTO(Builder builder) {
        this.saleId = builder.saleId;
        this.customerName = builder.customerName;
        this.customerPhone = builder.customerPhone;
        this.totalItems = builder.totalItems;
        this.totalAmount = builder.totalAmount;
        this.discountAmount = builder.discountAmount;
        this.paymentMethod = builder.paymentMethod;
        this.paymentStatus = builder.paymentStatus;
        this.saleDate = builder.saleDate;
    }

    // Getters et Setters
    public Integer getSaleId() {
        return saleId;
    }

    public void setSaleId(Integer saleId) {
        this.saleId = saleId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public Integer getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Integer totalItems) {
        this.totalItems = totalItems;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Double getDiscountAmount() {
        return discountAmount != null ? discountAmount : 0.0;
    }

    public void setDiscountAmount(Double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Date getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(Date saleDate) {
        this.saleDate = saleDate;
    }

    // Builder Pattern
    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Integer saleId;
        private String customerName;
        private String customerPhone;
        private Integer totalItems;
        private Double totalAmount;
        private Double discountAmount;
        private String paymentMethod;
        private String paymentStatus;
        private Date saleDate;

        public Builder saleId(Integer saleId) {
            this.saleId = saleId;
            return this;
        }

        public Builder customerName(String customerName) {
            this.customerName = customerName;
            return this;
        }

        public Builder customerPhone(String customerPhone) {
            this.customerPhone = customerPhone;
            return this;
        }

        public Builder totalItems(Integer totalItems) {
            this.totalItems = totalItems;
            return this;
        }

        public Builder totalAmount(Double totalAmount) {
            this.totalAmount = totalAmount;
            return this;
        }

        public Builder discountAmount(Double discountAmount) {
            this.discountAmount = discountAmount;
            return this;
        }

        public Builder paymentMethod(String paymentMethod) {
            this.paymentMethod = paymentMethod;
            return this;
        }

        public Builder paymentStatus(String paymentStatus) {
            this.paymentStatus = paymentStatus;
            return this;
        }

        public Builder saleDate(Date saleDate) {
            this.saleDate = saleDate;
            return this;
        }

        public SaleDTO build() {
            return new SaleDTO(this);
        }
    }

    @Override
    public String toString() {
        return "SaleDTO{" +
                "saleId=" + saleId +
                ", customerName='" + customerName + '\'' +
                ", totalAmount=" + totalAmount +
                ", paymentStatus='" + paymentStatus + '\'' +
                '}';
    }
}