package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.model.Supplier;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    private Connection getConnection() throws SQLException {
        return DatabaseConnection.getConnection();
    }

    public void insert(Supplier supplier) {
        String sql = "INSERT INTO suppliers (supplier_name, contact_person, phone, email, address, " +
                "city, country, reorder_level, is_active, barcode) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, supplier.getSupplierName());
            stmt.setString(2, supplier.getContactPerson());
            stmt.setString(3, supplier.getPhone());
            stmt.setString(4, supplier.getEmail());
            stmt.setString(5, supplier.getAddress());
            stmt.setString(6, supplier.getCity());
            stmt.setString(7, supplier.getCountry());
            stmt.setInt(8, supplier.getReorderLevel() != null ? supplier.getReorderLevel() : 10);
            stmt.setBoolean(9, supplier.getIsActive() != null ? supplier.getIsActive() : true);
            stmt.setString(10, supplier.getBarcode());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        supplier.setSupplierId(rs.getInt(1));
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion du fournisseur: " + e.getMessage(), e);
        }
    }

    public Supplier findById(Integer supplierId) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supplierId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractSupplier(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du fournisseur: " + e.getMessage(), e);
        }

        return null;
    }

    public List<Supplier> findAll() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY supplier_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                suppliers.add(extractSupplier(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de tous les fournisseurs: " + e.getMessage(), e);
        }

        return suppliers;
    }

    public List<Supplier> findActiveSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE is_active = TRUE ORDER BY supplier_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                suppliers.add(extractSupplier(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des fournisseurs actifs: " + e.getMessage(), e);
        }

        return suppliers;
    }

    public List<Supplier> searchByNameOrContact(String searchTerm) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE " +
                "LOWER(supplier_name) LIKE ? OR " +
                "LOWER(contact_person) LIKE ? OR " +
                "phone LIKE ? OR " +
                "email LIKE ? " +
                "ORDER BY supplier_name";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchLower = searchTerm.toLowerCase();
            String pattern = "%" + searchLower + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, "%" + searchTerm + "%");
            stmt.setString(4, "%" + searchTerm + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suppliers.add(extractSupplier(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des fournisseurs: " + e.getMessage(), e);
        }

        return suppliers;
    }

    public void update(Supplier supplier) {
        String sql = "UPDATE suppliers SET " +
                "supplier_name = ?, contact_person = ?, phone = ?, email = ?, " +
                "address = ?, city = ?, country = ?, reorder_level = ?, " +
                "is_active = ?, barcode = ?, updated_at = NOW() " +
                "WHERE supplier_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, supplier.getSupplierName());
            stmt.setString(2, supplier.getContactPerson());
            stmt.setString(3, supplier.getPhone());
            stmt.setString(4, supplier.getEmail());
            stmt.setString(5, supplier.getAddress());
            stmt.setString(6, supplier.getCity());
            stmt.setString(7, supplier.getCountry());
            stmt.setInt(8, supplier.getReorderLevel());
            stmt.setBoolean(9, supplier.getIsActive());
            stmt.setString(10, supplier.getBarcode());
            stmt.setInt(11, supplier.getSupplierId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du fournisseur: " + e.getMessage(), e);
        }
    }

    public void delete(Integer supplierId) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supplierId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du fournisseur: " + e.getMessage(), e);
        }
    }

    public void updateStatus(Integer supplierId, boolean active) {
        String sql = "UPDATE suppliers SET is_active = ?, updated_at = NOW() WHERE supplier_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, active);
            stmt.setInt(2, supplierId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du changement de statut du fournisseur: " + e.getMessage(), e);
        }
    }

    public boolean hasProducts(Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE supplier_id = ? AND quantity_in_stock > 0";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supplierId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification des produits du fournisseur: " + e.getMessage(), e);
        }

        return false;
    }

    public int getProductCount(Integer supplierId) {
        String sql = "SELECT COUNT(DISTINCT product_id) FROM inventory WHERE supplier_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supplierId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des produits du fournisseur: " + e.getMessage(), e);
        }

        return 0;
    }

    public int getLocalSuppliersCount() {
        String sql = "SELECT COUNT(*) FROM suppliers WHERE LOWER(country) = 'france'";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des fournisseurs locaux: " + e.getMessage(), e);
        }

        return 0;
    }

    // ============================
    // MÉTHODES DE PAGINATION
    // ============================

    public List<Supplier> getSuppliersWithPagination(int offset, int limit,
                                                     String search, String country, Boolean activeStatus) {

        List<Supplier> suppliers = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM suppliers WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(supplier_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(contact_person) LIKE LOWER(?) ");
            sql.append("OR phone LIKE ? ");
            sql.append("OR email LIKE ?) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre pays
        if (country != null && !country.trim().isEmpty()) {
            sql.append("AND LOWER(country) = LOWER(?) ");
            params.add(country);
        }

        // Filtre statut actif
        if (activeStatus != null) {
            sql.append("AND is_active = ? ");
            params.add(activeStatus);
        }

        sql.append("ORDER BY supplier_name ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(limit);
        params.add(offset);

        // ✅ CORRECT: try-with-resources avec gestion des paramètres
        try (Connection conn = getConnection();
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
                    suppliers.add(extractSupplier(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des fournisseurs: " + e.getMessage(), e);
        }

        return suppliers;
    }

    public long getTotalSuppliersCount(String search, String country, Boolean activeStatus) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM suppliers WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(supplier_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(contact_person) LIKE LOWER(?) ");
            sql.append("OR phone LIKE ? ");
            sql.append("OR email LIKE ?) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (country != null && !country.trim().isEmpty()) {
            sql.append("AND LOWER(country) = LOWER(?) ");
            params.add(country);
        }

        if (activeStatus != null) {
            sql.append("AND is_active = ? ");
            params.add(activeStatus);
        }

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
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
            throw new RuntimeException("Erreur lors du comptage des fournisseurs: " + e.getMessage(), e);
        }

        return 0;
    }

    public List<String> getAllCountries() {
        List<String> countries = new ArrayList<>();
        String sql = "SELECT DISTINCT country FROM suppliers WHERE country IS NOT NULL AND country != '' ORDER BY country";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                countries.add(rs.getString("country"));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des pays: " + e.getMessage(), e);
        }

        return countries;
    }

    public boolean supplierNameExists(String supplierName, Integer excludeId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM suppliers WHERE LOWER(supplier_name) = LOWER(?) ");

        List<Object> params = new ArrayList<>();
        params.add(supplierName);

        if (excludeId != null) {
            sql.append("AND supplier_id != ? ");
            params.add(excludeId);
        }

        // ✅ CORRECT: try-with-resources
        try (Connection conn = getConnection();
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
            throw new RuntimeException("Erreur lors de la vérification du nom de fournisseur: " + e.getMessage(), e);
        }

        return false;
    }

    // ============================
    // MÉTHODES UTILITAIRES
    // ============================

    private Supplier extractSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();

        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setSupplierName(rs.getString("supplier_name"));
        supplier.setContactPerson(rs.getString("contact_person"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        supplier.setAddress(rs.getString("address"));
        supplier.setCity(rs.getString("city"));
        supplier.setCountry(rs.getString("country"));
        supplier.setReorderLevel(rs.getInt("reorder_level"));
        supplier.setIsActive(rs.getBoolean("is_active"));
        supplier.setBarcode(rs.getString("barcode"));

        // Ajouter le mapping des dates si votre classe Supplier les a
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            supplier.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            supplier.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return supplier;
    }
}