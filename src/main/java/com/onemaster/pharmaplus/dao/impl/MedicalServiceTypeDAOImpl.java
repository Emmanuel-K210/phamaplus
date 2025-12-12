package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.MedicalServiceTypeDAO;
import com.onemaster.pharmaplus.model.MedicalServiceType;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MedicalServiceTypeDAOImpl implements MedicalServiceTypeDAO {
    
    @Override
    public Integer save(MedicalServiceType serviceType) {
        String sql = "INSERT INTO medical_service_types " +
                     "(service_code, service_name, service_category, default_price, " +
                     "is_active, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?) " +
                     "RETURNING service_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceType.getServiceCode());
            pstmt.setString(2, serviceType.getServiceName());
            pstmt.setString(3, serviceType.getServiceCategory());
            pstmt.setDouble(4, serviceType.getDefaultPrice());
            pstmt.setBoolean(5, serviceType.getIsActive());
            pstmt.setString(6, serviceType.getDescription());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("service_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public MedicalServiceType findById(Integer id) {
        String sql = "SELECT * FROM medical_service_types WHERE service_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToServiceType(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public MedicalServiceType findByCode(String serviceCode) {
        String sql = "SELECT * FROM medical_service_types WHERE service_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToServiceType(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public List<MedicalServiceType> findAll() {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types ORDER BY service_category, service_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                serviceTypes.add(mapResultSetToServiceType(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceTypes;
    }
    
    @Override
    public List<MedicalServiceType> findByCategory(String category) {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types WHERE service_category = ? ORDER BY service_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    serviceTypes.add(mapResultSetToServiceType(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceTypes;
    }
    
    @Override
    public List<MedicalServiceType> findActiveServices() {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types WHERE is_active = true ORDER BY service_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                serviceTypes.add(mapResultSetToServiceType(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceTypes;
    }
    
    @Override
    public boolean update(MedicalServiceType serviceType) {
        String sql = "UPDATE medical_service_types SET " +
                     "service_name = ?, service_category = ?, default_price = ?, " +
                     "is_active = ?, description = ? " +
                     "WHERE service_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceType.getServiceName());
            pstmt.setString(2, serviceType.getServiceCategory());
            pstmt.setDouble(3, serviceType.getDefaultPrice());
            pstmt.setBoolean(4, serviceType.getIsActive());
            pstmt.setString(5, serviceType.getDescription());
            pstmt.setInt(6, serviceType.getServiceId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM medical_service_types WHERE service_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean deactivate(Integer id) {
        String sql = "UPDATE medical_service_types SET is_active = false WHERE service_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean activate(Integer id) {
        String sql = "UPDATE medical_service_types SET is_active = true WHERE service_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Méthodes supplémentaires
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT service_category FROM medical_service_types ORDER BY service_category";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(rs.getString("service_category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    public Double getServicePrice(String serviceCode) {
        String sql = "SELECT default_price FROM medical_service_types WHERE service_code = ? AND is_active = true";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("default_price");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private MedicalServiceType mapResultSetToServiceType(ResultSet rs) throws SQLException {
        MedicalServiceType serviceType = new MedicalServiceType();
        
        serviceType.setServiceId(rs.getInt("service_id"));
        serviceType.setServiceCode(rs.getString("service_code"));
        serviceType.setServiceName(rs.getString("service_name"));
        serviceType.setServiceCategory(rs.getString("service_category"));
        serviceType.setDefaultPrice(rs.getDouble("default_price"));
        serviceType.setIsActive(rs.getBoolean("is_active"));
        serviceType.setDescription(rs.getString("description"));
        
        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            serviceType.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return serviceType;
    }
}