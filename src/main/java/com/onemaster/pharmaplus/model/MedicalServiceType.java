package com.onemaster.pharmaplus.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class MedicalServiceType {
    private Integer serviceId;
    private String serviceCode;
    private String serviceName;
    private String serviceCategory;
    private Double defaultPrice;
    private Boolean isActive;
    private String description;
    private LocalDateTime createdAt;
    
    // Constructeurs
    public MedicalServiceType() {
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
    }
    
    public MedicalServiceType(String serviceCode, String serviceName, String serviceCategory, Double defaultPrice) {
        this();
        this.serviceCode = serviceCode;
        this.serviceName = serviceName;
        this.serviceCategory = serviceCategory;
        this.defaultPrice = defaultPrice;
    }
    
    // Getters et Setters
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public String getServiceCode() {
        return serviceCode;
    }
    
    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getServiceCategory() {
        return serviceCategory;
    }
    
    public void setServiceCategory(String serviceCategory) {
        this.serviceCategory = serviceCategory;
    }
    
    public Double getDefaultPrice() {
        return defaultPrice;
    }
    
    public void setDefaultPrice(Double defaultPrice) {
        this.defaultPrice = defaultPrice;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Date getCreatedAtAsDate() {
        return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // Méthodes utilitaires
    public String getFormattedPrice() {
        if (defaultPrice != null) {
            java.text.DecimalFormat df = new java.text.DecimalFormat("#,##0");
            return df.format(defaultPrice) + " F CFA";
        }
        return "0 F CFA";
    }
    
    public boolean isConsultation() {
        return "Consultation".equalsIgnoreCase(serviceCategory);
    }
    
    public boolean isExamen() {
        return "Examen".equalsIgnoreCase(serviceCategory);
    }
    
    // Builder pattern
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private MedicalServiceType serviceType;
        
        public Builder() {
            serviceType = new MedicalServiceType();
        }
        
        public Builder serviceCode(String serviceCode) {
            serviceType.serviceCode = serviceCode;
            return this;
        }
        
        public Builder serviceName(String serviceName) {
            serviceType.serviceName = serviceName;
            return this;
        }
        
        public Builder serviceCategory(String serviceCategory) {
            serviceType.serviceCategory = serviceCategory;
            return this;
        }
        
        public Builder defaultPrice(Double defaultPrice) {
            serviceType.defaultPrice = defaultPrice;
            return this;
        }
        
        public Builder isActive(Boolean isActive) {
            serviceType.isActive = isActive;
            return this;
        }
        
        public Builder description(String description) {
            serviceType.description = description;
            return this;
        }
        
        public MedicalServiceType build() {
            return serviceType;
        }
    }
    
    // equals, hashCode et toString
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        MedicalServiceType that = (MedicalServiceType) o;
        
        if (serviceId != null ? !serviceId.equals(that.serviceId) : that.serviceId != null) return false;
        return serviceCode != null ? serviceCode.equals(that.serviceCode) : that.serviceCode == null;
    }
    
    @Override
    public int hashCode() {
        int result = serviceId != null ? serviceId.hashCode() : 0;
        result = 31 * result + (serviceCode != null ? serviceCode.hashCode() : 0);
        return result;
    }
    
    @Override
    public String toString() {
        return "MedicalServiceType{" +
                "serviceId=" + serviceId +
                ", serviceCode='" + serviceCode + '\'' +
                ", serviceName='" + serviceName + '\'' +
                ", serviceCategory='" + serviceCategory + '\'' +
                ", defaultPrice=" + defaultPrice +
                ", isActive=" + isActive +
                '}';
    }
}