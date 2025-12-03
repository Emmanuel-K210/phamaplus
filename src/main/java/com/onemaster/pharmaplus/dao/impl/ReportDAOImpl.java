package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.ReportDAO;
import com.onemaster.pharmaplus.model.Report;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAOImpl implements ReportDAO {
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    public void insert(Report report) {
        String sql = "INSERT INTO reports (report_type, report_name, description, " +
                     "start_date, end_date, parameters, format, status, file_path, " +
                     "generated_at, generated_by, report_data, summary, details) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, report.getReportType());
            stmt.setString(2, report.getReportName());
            stmt.setString(3, report.getDescription());
            
            if (report.getStartDate() != null) {
                stmt.setDate(4, Date.valueOf(report.getStartDate()));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            
            if (report.getEndDate() != null) {
                stmt.setDate(5, Date.valueOf(report.getEndDate()));
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            stmt.setString(6, mapToJson(report.getParameters()));
            stmt.setString(7, report.getFormat());
            stmt.setString(8, report.getStatus());
            stmt.setString(9, report.getFilePath());
            
            if (report.getGeneratedAt() != null) {
                stmt.setTimestamp(10, Timestamp.valueOf(report.getGeneratedAt()));
            } else {
                stmt.setNull(10, Types.TIMESTAMP);
            }
            
            stmt.setString(11, report.getGeneratedBy());
            stmt.setString(12, report.getData());
            stmt.setString(13, mapToJson(report.getSummary()));
            // Utiliser la méthode spécifique pour details (liste)
            stmt.setString(14, listToJson(report.getDetails()));
            
            stmt.executeUpdate();
            
            // Récupérer l'ID généré
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    report.setReportId(generatedKeys.getInt(1));
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion du rapport", e);
        }
    }
    
    @Override
    public void update(Report report) {
        String sql = "UPDATE reports SET report_type = ?, report_name = ?, description = ?, " +
                     "start_date = ?, end_date = ?, parameters = ?, format = ?, status = ?, " +
                     "file_path = ?, generated_at = ?, generated_by = ?, report_data = ?, " +
                     "summary = ?, details = ? WHERE report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, report.getReportType());
            stmt.setString(2, report.getReportName());
            stmt.setString(3, report.getDescription());
            
            if (report.getStartDate() != null) {
                stmt.setDate(4, Date.valueOf(report.getStartDate()));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            
            if (report.getEndDate() != null) {
                stmt.setDate(5, Date.valueOf(report.getEndDate()));
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            stmt.setString(6, mapToJson(report.getParameters()));
            stmt.setString(7, report.getFormat());
            stmt.setString(8, report.getStatus());
            stmt.setString(9, report.getFilePath());
            
            if (report.getGeneratedAt() != null) {
                stmt.setTimestamp(10, Timestamp.valueOf(report.getGeneratedAt()));
            } else {
                stmt.setNull(10, Types.TIMESTAMP);
            }
            
            stmt.setString(11, report.getGeneratedBy());
            stmt.setString(12, report.getData());
            stmt.setString(13, mapToJson(report.getSummary()));
            stmt.setString(14, listToJson(report.getDetails()));
            stmt.setInt(15, report.getReportId());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Rapport non trouvé avec l'ID: " + report.getReportId());
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du rapport", e);
        }
    }
    
    @Override
    public void delete(Integer reportId) {
        String sql = "DELETE FROM reports WHERE report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reportId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Rapport non trouvé avec l'ID: " + reportId);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du rapport", e);
        }
    }
    
    @Override
    public Report findById(Integer reportId) {
        String sql = "SELECT * FROM reports WHERE report_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reportId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapFromResultSet(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du rapport", e);
        }
        return null;
    }
    
    @Override
    public List<Report> findAll() {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM reports ORDER BY generated_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                reports.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des rapports", e);
        }
        return reports;
    }
    
    @Override
    public List<Report> findByType(String reportType) {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM reports WHERE report_type = ? ORDER BY generated_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reportType);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reports.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des rapports par type", e);
        }
        return reports;
    }
    
    @Override
    public List<Report> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM reports WHERE start_date >= ? AND end_date <= ? ORDER BY start_date";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reports.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des rapports par date", e);
        }
        return reports;
    }
    
    @Override
    public List<Report> findRecentReports(int limit) {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM reports ORDER BY generated_at DESC LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                reports.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des rapports récents", e);
        }
        return reports;
    }
    
    @Override
    public int countByType(String reportType) {
        String sql = "SELECT COUNT(*) FROM reports WHERE report_type = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reportType);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des rapports", e);
        }
        return 0;
    }
    
    @Override
    public Map<String, Integer> getReportStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT report_type, COUNT(*) as count FROM reports GROUP BY report_type";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                stats.put(rs.getString("report_type"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des statistiques", e);
        }
        return stats;
    }
    
    // Méthode de mapping
    private Report mapFromResultSet(ResultSet rs) throws SQLException {
        Report report = new Report();
        
        report.setReportId(rs.getInt("report_id"));
        report.setReportType(rs.getString("report_type"));
        report.setReportName(rs.getString("report_name"));
        report.setDescription(rs.getString("description"));
        
        Date startDate = rs.getDate("start_date");
        if (startDate != null) {
            report.setStartDate(startDate.toLocalDate());
        }
        
        Date endDate = rs.getDate("end_date");
        if (endDate != null) {
            report.setEndDate(endDate.toLocalDate());
        }
        
        report.setParameters(jsonToMap(rs.getString("parameters")));
        report.setFormat(rs.getString("format"));
        report.setStatus(rs.getString("status"));
        report.setFilePath(rs.getString("file_path"));
        
        Timestamp generatedAt = rs.getTimestamp("generated_at");
        if (generatedAt != null) {
            report.setGeneratedAt(generatedAt.toLocalDateTime());
        }
        
        report.setGeneratedBy(rs.getString("generated_by"));
        report.setData(rs.getString("report_data"));
        report.setSummary(jsonToMap(rs.getString("summary")));
        report.setDetails(jsonToList(rs.getString("details")));
        
        return report;
    }
    
    // Méthodes utilitaires JSON
    private String mapToJson(Map<String, Object> map) {
        if (map == null || map.isEmpty()) {
            return "{}";
        }
        try {
            return objectMapper.writeValueAsString(map);
        } catch (Exception e) {
            return "{}";
        }
    }
    
    private String listToJson(List<Map<String, Object>> list) {
        if (list == null || list.isEmpty()) {
            return "[]";
        }
        try {
            return objectMapper.writeValueAsString(list);
        } catch (Exception e) {
            return "[]";
        }
    }
    
    private Map<String, Object> jsonToMap(String json) {
        if (json == null || json.trim().isEmpty() || json.equals("{}")) {
            return new HashMap<>();
        }
        try {
            return objectMapper.readValue(json, new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            return new HashMap<>();
        }
    }
    
    private List<Map<String, Object>> jsonToList(String json) {
        if (json == null || json.trim().isEmpty() || json.equals("[]")) {
            return new ArrayList<>();
        }
        try {
            return objectMapper.readValue(json, new TypeReference<List<Map<String, Object>>>() {});
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}