package com.onemaster.pharmaplus.model;

import java.time.LocalDateTime;

public class ApplicationParameter {
    private Integer parameterId;
    private String parameterKey;
    private String parameterValue;
    private String parameterType; // STRING, INTEGER, BOOLEAN, DATE, DECIMAL
    private String category; // GENERAL, UI, SECURITY, EMAIL, NOTIFICATION, etc.
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getDataType() {
        return parameterType;
    }
    // Constructeurs
    public ApplicationParameter() {}
    
    public ApplicationParameter(String parameterKey, String parameterValue, String parameterType, String category) {
        this.parameterKey = parameterKey;
        this.parameterValue = parameterValue;
        this.parameterType = parameterType;
        this.category = category;
    }
    
    // Getters et Setters
    public Integer getParameterId() { return parameterId; }
    public void setParameterId(Integer parameterId) { this.parameterId = parameterId; }
    
    public String getParameterKey() { return parameterKey; }
    public void setParameterKey(String parameterKey) { this.parameterKey = parameterKey; }
    
    public String getParameterValue() { return parameterValue; }
    public void setParameterValue(String parameterValue) { this.parameterValue = parameterValue; }
    
    public String getParameterType() { return parameterType; }
    public void setParameterType(String parameterType) { this.parameterType = parameterType; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // Méthodes utilitaires pour convertir les types
    public Integer getAsInteger() {
        try {
            return Integer.parseInt(parameterValue);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    public Boolean getAsBoolean() {
        return Boolean.parseBoolean(parameterValue);
    }
    
    public Double getAsDouble() {
        try {
            return Double.parseDouble(parameterValue);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}