package com.onemaster.pharmaplus.dao.impl;


import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.ProductDAO;
import com.onemaster.pharmaplus.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {
    
    private Connection connection;
    
    public ProductDAOImpl() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    @Override
    public void insert(Product product) {
        String sql = "INSERT INTO products (product_name, generic_name, category_id, manufacturer, " +
                     "dosage_form, strength, unit_of_measure, requires_prescription, " +
                     "unit_price, selling_price, reorder_level, barcode, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setProductParameters(stmt, product);
            stmt.setBoolean(13, product.getIsActive() != null ? product.getIsActive() : true);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        product.setProductId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de l'insertion produit: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void update(Product product) {
        String sql = "UPDATE products SET product_name = ?, generic_name = ?, category_id = ?, " +
                     "manufacturer = ?, dosage_form = ?, strength = ?, unit_of_measure = ?, " +
                     "requires_prescription = ?, unit_price = ?, selling_price = ?, " +
                     "reorder_level = ?, barcode = ?, is_active = ?, updated_at = NOW() " +
                     "WHERE product_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setProductParameters(stmt, product);
            stmt.setBoolean(13, product.getIsActive() != null ? product.getIsActive() : true);
            stmt.setInt(14, product.getProductId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur lors de la mise à jour produit: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void delete(Integer productId) {
        String sql = "UPDATE products SET is_active = false, updated_at = NOW() WHERE product_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur lors de la suppression produit: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public Product findById(Integer productId) {
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.product_id = ? AND p.is_active = true";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProductWithCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public Product findByBarcode(String barcode) {
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.barcode = ? AND p.is_active = true";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, barcode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProductWithCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par code-barres: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.is_active = true ORDER BY p.product_name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                products.add(mapProductWithCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des produits: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public List<Product> findByName(String name) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE (LOWER(p.product_name) LIKE LOWER(?) OR LOWER(p.generic_name) LIKE LOWER(?)) " +
                     "AND p.is_active = true ORDER BY p.product_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchTerm = "%" + name + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProductWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par nom: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public List<Product> findByCategory(Integer categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.category_id = ? AND p.is_active = true ORDER BY p.product_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProductWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par catégorie: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public List<Product> findActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.is_active = true ORDER BY p.product_name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                products.add(mapProductWithCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public List<Product> findLowStockProducts() {
        List<Product> products = new ArrayList<>();
        // Utilisation de la vue v_current_stock
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN v_current_stock v ON p.product_id = v.product_id " +
                     "WHERE p.is_active = true AND v.stock_status = 'LOW STOCK' " +
                     "ORDER BY p.product_name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                products.add(mapProductWithCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur produits en rupture: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public List<Product> findRequiringPrescription() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.requires_prescription = true AND p.is_active = true " +
                     "ORDER BY p.product_name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                products.add(mapProductWithCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = true";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur comptage: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    @Override
    public int countByCategory(Integer categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ? AND is_active = true";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur comptage par catégorie: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    @Override
    public void updateStock(Integer productId, Integer quantityChange) {
        // Cette méthode pourrait être remplacée par un trigger
        String sql = "UPDATE products SET updated_at = NOW() WHERE product_id = ?";
        // Pour le stock réel, on utilise la table inventory
        System.out.println("Mise à jour du stock pour produit ID: " + productId + ", changement: " + quantityChange);
    }
    
    // ========== HELPER METHODS ==========
    
    private void setProductParameters(PreparedStatement stmt, Product product) throws SQLException {
        stmt.setString(1, product.getProductName());
        stmt.setString(2, product.getGenericName());
        stmt.setObject(3, product.getCategoryId(), Types.INTEGER);
        stmt.setString(4, product.getManufacturer());
        stmt.setString(5, product.getDosageForm());
        stmt.setString(6, product.getStrength());
        stmt.setString(7, product.getUnitOfMeasure());
        stmt.setBoolean(8, product.getRequiresPrescription() != null ? product.getRequiresPrescription() : false);
        stmt.setDouble(9, product.getUnitPrice() != null ? product.getUnitPrice() : 0.0);
        stmt.setDouble(10, product.getSellingPrice() != null ? product.getSellingPrice() : 0.0);
        stmt.setInt(11, product.getReorderLevel() != null ? product.getReorderLevel() : 10);
        stmt.setString(12, product.getBarcode());
    }
    
    private Product mapProductWithCategory(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setGenericName(rs.getString("generic_name"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setManufacturer(rs.getString("manufacturer"));
        product.setDosageForm(rs.getString("dosage_form"));
        product.setStrength(rs.getString("strength"));
        product.setUnitOfMeasure(rs.getString("unit_of_measure"));
        product.setRequiresPrescription(rs.getBoolean("requires_prescription"));
        product.setUnitPrice(rs.getDouble("unit_price"));
        product.setSellingPrice(rs.getDouble("selling_price"));
        product.setReorderLevel(rs.getInt("reorder_level"));
        product.setBarcode(rs.getString("barcode"));
        product.setIsActive(rs.getBoolean("is_active"));
        product.setCreatedAt(rs.getTimestamp("created_at") != null ? 
            rs.getTimestamp("created_at").toLocalDateTime() : null);
        product.setUpdatedAt(rs.getTimestamp("updated_at") != null ? 
            rs.getTimestamp("updated_at").toLocalDateTime() : null);
        
        // Champ de jointure
        product.setCategoryName(rs.getString("category_name"));
        
        return product;
    }
}