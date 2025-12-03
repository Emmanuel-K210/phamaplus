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
            throw new RuntimeException("Erreur lors de l'insertion du fournisseur", e);
        }
    }
    
    public Supplier findById(Integer supplierId) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractSupplier(rs);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du fournisseur", e);
        }
        return null;
    }
    
    public List<Supplier> findAll() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY supplier_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                suppliers.add(extractSupplier(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des fournisseurs", e);
        }
        return suppliers;
    }
    
    public List<Supplier> findActiveSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE is_active = TRUE ORDER BY supplier_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                suppliers.add(extractSupplier(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des fournisseurs actifs", e);
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
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String pattern = "%" + searchTerm.toLowerCase() + "%";
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
            throw new RuntimeException("Erreur lors de la recherche des fournisseurs", e);
        }
        return suppliers;
    }
    
    public void update(Supplier supplier) {
        String sql = "UPDATE suppliers SET " +
                    "supplier_name = ?, contact_person = ?, phone = ?, email = ?, " +
                    "address = ?, city = ?, country = ?, reorder_level = ?, " +
                    "is_active = ?, barcode = ?, updated_at = NOW() " +
                    "WHERE supplier_id = ?";
        
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
            throw new RuntimeException("Erreur lors de la mise à jour du fournisseur", e);
        }
    }
    
    public void delete(Integer supplierId) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du fournisseur", e);
        }
    }
    
    public void updateStatus(Integer supplierId, boolean active) {
        String sql = "UPDATE suppliers SET is_active = ?, updated_at = NOW() WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, active);
            stmt.setInt(2, supplierId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du changement de statut du fournisseur", e);
        }
    }
    
    public boolean hasProducts(Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE supplier_id = ? AND quantity_in_stock > 0";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification des produits", e);
        }
        return false;
    }
    
    public int getProductCount(Integer supplierId) {
        String sql = "SELECT COUNT(DISTINCT product_id) FROM inventory WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des produits", e);
        }
        return 0;
    }
    
    public int getLocalSuppliersCount() {
        String sql = "SELECT COUNT(*) FROM suppliers WHERE LOWER(country) = 'france'";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des fournisseurs locaux", e);
        }
        return 0;
    }
    
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
        
        return supplier;
    }
}