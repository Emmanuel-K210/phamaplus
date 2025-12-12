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

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, serviceType.getServiceCode());
            stmt.setString(2, serviceType.getServiceName());
            stmt.setString(3, serviceType.getServiceCategory());
            stmt.setDouble(4, serviceType.getDefaultPrice());
            stmt.setBoolean(5, serviceType.getIsActive());
            stmt.setString(6, serviceType.getDescription());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("service_id");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la sauvegarde du type de service médical: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public MedicalServiceType findById(Integer id) {
        String sql = "SELECT * FROM medical_service_types WHERE service_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToServiceType(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du type de service par ID: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public MedicalServiceType findByCode(String serviceCode) {
        String sql = "SELECT * FROM medical_service_types WHERE service_code = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, serviceCode);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToServiceType(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du type de service par code: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public List<MedicalServiceType> findAll() {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types ORDER BY service_category, service_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                serviceTypes.add(mapResultSetToServiceType(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de tous les types de service: " + e.getMessage(), e);
        }

        return serviceTypes;
    }

    @Override
    public List<MedicalServiceType> findByCategory(String category) {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types WHERE service_category = ? ORDER BY service_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    serviceTypes.add(mapResultSetToServiceType(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche par catégorie: " + e.getMessage(), e);
        }

        return serviceTypes;
    }

    @Override
    public List<MedicalServiceType> findActiveServices() {
        List<MedicalServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM medical_service_types WHERE is_active = true ORDER BY service_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                serviceTypes.add(mapResultSetToServiceType(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des services actifs: " + e.getMessage(), e);
        }

        return serviceTypes;
    }

    @Override
    public boolean update(MedicalServiceType serviceType) {
        String sql = "UPDATE medical_service_types SET " +
                "service_name = ?, service_category = ?, default_price = ?, " +
                "is_active = ?, description = ?, updated_at = NOW() " +
                "WHERE service_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, serviceType.getServiceName());
            stmt.setString(2, serviceType.getServiceCategory());
            stmt.setDouble(3, serviceType.getDefaultPrice());
            stmt.setBoolean(4, serviceType.getIsActive());
            stmt.setString(5, serviceType.getDescription());
            stmt.setInt(6, serviceType.getServiceId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du type de service: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM medical_service_types WHERE service_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du type de service: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean deactivate(Integer id) {
        String sql = "UPDATE medical_service_types SET is_active = false, updated_at = NOW() WHERE service_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la désactivation du service: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean activate(Integer id) {
        String sql = "UPDATE medical_service_types SET is_active = true, updated_at = NOW() WHERE service_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'activation du service: " + e.getMessage(), e);
        }
    }

    // ============================
    // MÉTHODES SUPPLÉMENTAIRES
    // ============================

    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT service_category FROM medical_service_types ORDER BY service_category";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(rs.getString("service_category"));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des catégories: " + e.getMessage(), e);
        }

        return categories;
    }

    public Double getServicePrice(String serviceCode) {
        String sql = "SELECT default_price FROM medical_service_types WHERE service_code = ? AND is_active = true";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, serviceCode);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("default_price");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération du prix du service: " + e.getMessage(), e);
        }

        return null;
    }

    // ============================
    // MÉTHODES DE PAGINATION
    // ============================

    public List<MedicalServiceType> getServicesWithPagination(int offset, int limit,
                                                              String search, String category, Boolean activeStatus) {
        List<MedicalServiceType> services = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM medical_service_types WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(service_code) LIKE LOWER(?) ");
            sql.append("OR LOWER(service_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(description) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre catégorie
        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND service_category = ? ");
            params.add(category);
        }

        // Filtre statut actif
        if (activeStatus != null) {
            sql.append("AND is_active = ? ");
            params.add(activeStatus);
        }

        sql.append("ORDER BY service_category, service_name ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(limit);
        params.add(offset);

        // ✅ CORRECT: try-with-resources avec gestion des paramètres
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Boolean) {
                    stmt.setBoolean(i + 1, (Boolean) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToServiceType(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des services: " + e.getMessage(), e);
        }

        return services;
    }

    public long getTotalServicesCount(String search, String category, Boolean activeStatus) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM medical_service_types WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(service_code) LIKE LOWER(?) ");
            sql.append("OR LOWER(service_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(description) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND service_category = ? ");
            params.add(category);
        }

        if (activeStatus != null) {
            sql.append("AND is_active = ? ");
            params.add(activeStatus);
        }

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Boolean) {
                    stmt.setBoolean(i + 1, (Boolean) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des services: " + e.getMessage(), e);
        }

        return 0;
    }

    public boolean serviceCodeExists(String serviceCode, Integer excludeId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM medical_service_types WHERE service_code = ? ");

        List<Object> params = new ArrayList<>();
        params.add(serviceCode);

        if (excludeId != null) {
            sql.append("AND service_id != ? ");
            params.add(excludeId);
        }

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification du code de service: " + e.getMessage(), e);
        }

        return false;
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

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            serviceType.setCreatedAt(createdAt.toLocalDateTime());
        }

        return serviceType;
    }
}