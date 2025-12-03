package com.onemaster.pharmaplus.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.List;

public class Report {
    private Integer reportId;
    private String reportType; // SALES, STOCK, CUSTOMER, FINANCIAL, PRESCRIPTION
    private String reportName;
    private String description;
    private LocalDate startDate;
    private LocalDate endDate;
    private Map<String, Object> parameters; // Paramètres du rapport
    private String format; // PDF, EXCEL, CSV, HTML
    private String status; // PENDING, GENERATING, COMPLETED, FAILED
    private String filePath;
    private LocalDateTime generatedAt;
    private String generatedBy;
    
    // Données du rapport (stockées sous forme JSON ou dans une table séparée)
    private String data;
    private Map<String, Object> summary; // Résumé/synthèse
    private List<Map<String, Object>> details; // Détails
    
    // Constructeurs
    public Report() {}
    
    public Report(String reportType, String reportName, LocalDate startDate, LocalDate endDate) {
        this.reportType = reportType;
        this.reportName = reportName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = "PENDING";
    }
    
    // Getters et Setters
    public Integer getReportId() { return reportId; }
    public void setReportId(Integer reportId) { this.reportId = reportId; }
    
    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
    
    public String getReportName() { return reportName; }
    public void setReportName(String reportName) { this.reportName = reportName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    
    public Map<String, Object> getParameters() { return parameters; }
    public void setParameters(Map<String, Object> parameters) { this.parameters = parameters; }
    
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    
    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }
    
    public String getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(String generatedBy) { this.generatedBy = generatedBy; }
    
    public String getData() { return data; }
    public void setData(String data) { this.data = data; }
    
    public Map<String, Object> getSummary() { return summary; }
    public void setSummary(Map<String, Object> summary) { this.summary = summary; }
    
    public List<Map<String, Object>> getDetails() { return details; }
    public void setDetails(List<Map<String, Object>> details) { this.details = details; }
}

// Enum pour les types de rapports
enum ReportType {
    SALES("Ventes"),
    STOCK("Stock"),
    CUSTOMER("Clients"),
    FINANCIAL("Financier"),
    PRESCRIPTION("Ordonnances"),
    INVENTORY("Inventaire"),
    PRODUCT("Produits"),
    EMPLOYEE("Employés"),
    DAILY("Journalier"),
    MONTHLY("Mensuel"),
    YEARLY("Annuel");
    
    private final String label;
    
    ReportType(String label) {
        this.label = label;
    }
    
    public String getLabel() {
        return label;
    }
}