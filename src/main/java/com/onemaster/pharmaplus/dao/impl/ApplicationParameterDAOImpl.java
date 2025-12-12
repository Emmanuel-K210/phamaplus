package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.ApplicationParameterDAO;
import com.onemaster.pharmaplus.model.ApplicationParameter;
import com.onemaster.pharmaplus.utils.JdbcUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ApplicationParameterDAOImpl implements ApplicationParameterDAO {

    @Override
    public void insert(ApplicationParameter parameter) {
        String sql = "INSERT INTO application_parameters (parameter_key, parameter_value, " +
                "parameter_type, category, description) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, parameter.getParameterKey());
            stmt.setString(2, parameter.getParameterValue());
            stmt.setString(3, parameter.getParameterType());
            stmt.setString(4, parameter.getCategory());
            stmt.setString(5, parameter.getDescription());

            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion du paramètre", e);
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    @Override
    public void update(ApplicationParameter parameter) {
        String sql = "UPDATE application_parameters SET parameter_value = ?, " +
                "parameter_type = ?, category = ?, description = ?, " +
                "updated_at = NOW() WHERE parameter_key = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, parameter.getParameterValue());
            stmt.setString(2, parameter.getParameterType());
            stmt.setString(3, parameter.getCategory());
            stmt.setString(4, parameter.getDescription());
            stmt.setString(5, parameter.getParameterKey());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Paramètre non trouvé: " + parameter.getParameterKey());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du paramètre", e);
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    @Override
    public void delete(String parameterKey) {
        String sql = "DELETE FROM application_parameters WHERE parameter_key = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, parameterKey);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Paramètre non trouvé: " + parameterKey);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du paramètre", e);
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    @Override
    public ApplicationParameter findByKey(String parameterKey) {
        String sql = "SELECT * FROM application_parameters WHERE parameter_key = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, parameterKey);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapFromResultSet(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du paramètre", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return null;
    }

    @Override
    public List<ApplicationParameter> findAll() {
        List<ApplicationParameter> parameters = new ArrayList<>();
        String sql = "SELECT * FROM application_parameters ORDER BY category, parameter_key";

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                parameters.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des paramètres", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return parameters;
    }

    @Override
    public List<ApplicationParameter> findByCategory(String category) {
        List<ApplicationParameter> parameters = new ArrayList<>();
        String sql = "SELECT * FROM application_parameters WHERE category = ? ORDER BY parameter_key";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category);
            rs = stmt.executeQuery();

            while (rs.next()) {
                parameters.add(mapFromResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des paramètres par catégorie", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return parameters;
    }

    @Override
    public Map<String, String> getAllAsMap() {
        Map<String, String> parameters = new HashMap<>();
        String sql = "SELECT parameter_key, parameter_value FROM application_parameters";

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                parameters.put(rs.getString("parameter_key"), rs.getString("parameter_value"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des paramètres en map", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return parameters;
    }

    @Override
    public boolean existsByKey(String parameterKey) {
        String sql = "SELECT COUNT(*) FROM application_parameters WHERE parameter_key = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, parameterKey);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification du paramètre", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return false;
    }

    // Méthodes utilitaires
    @Override
    public String getValue(String parameterKey, String defaultValue) {
        ApplicationParameter param = findByKey(parameterKey);
        return param != null ? param.getParameterValue() : defaultValue;
    }

    @Override
    public Integer getIntValue(String parameterKey, Integer defaultValue) {
        ApplicationParameter param = findByKey(parameterKey);
        if (param != null) {
            try {
                return Integer.parseInt(param.getParameterValue());
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    @Override
    public Boolean getBooleanValue(String parameterKey, Boolean defaultValue) {
        ApplicationParameter param = findByKey(parameterKey);
        return param != null ? Boolean.parseBoolean(param.getParameterValue()) : defaultValue;
    }

    @Override
    public Double getDoubleValue(String parameterKey, Double defaultValue) {
        ApplicationParameter param = findByKey(parameterKey);
        if (param != null) {
            try {
                return Double.parseDouble(param.getParameterValue());
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    private ApplicationParameter mapFromResultSet(ResultSet rs) throws SQLException {
        ApplicationParameter parameter = new ApplicationParameter();

        parameter.setParameterId(rs.getInt("parameter_id"));
        parameter.setParameterKey(rs.getString("parameter_key"));
        parameter.setParameterValue(rs.getString("parameter_value"));
        parameter.setParameterType(rs.getString("parameter_type"));
        parameter.setCategory(rs.getString("category"));
        parameter.setDescription(rs.getString("description"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            parameter.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            parameter.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return parameter;
    }
}