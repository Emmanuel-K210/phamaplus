package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.ProductDAO;
import com.onemaster.pharmaplus.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public void insert(Product product) {
        String sql = "INSERT INTO products (product_name, generic_name, category_id, manufacturer, " +
                "dosage_form, strength, unit_of_measure, requires_prescription, " +
                "unit_price, selling_price, reorder_level, barcode, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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
                "WHERE p.product_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
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

        String sql = "SELECT p.*, c.category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE p.is_active = true AND p.product_id IN ( " +
                "    SELECT i.product_id FROM inventory i " +
                "    WHERE i.quantity_in_stock > 0 " +
                "    GROUP BY i.product_id " +
                "    HAVING SUM(i.quantity_in_stock) <= p.reorder_level " +
                ") ORDER BY p.product_name";

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
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

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
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

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
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

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
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
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur mise à jour stock: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ========== NOUVELLES MÉTHODES POUR PAGINATION ==========

    public List<Product> getProductsWithPagination(int offset, int limit, String search, String category, String status) {
        List<Product> products = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.*, c.category_name FROM products p ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(p.product_name) LIKE LOWER(?) OR LOWER(p.generic_name) LIKE LOWER(?) OR p.barcode LIKE ?) ");
            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre catégorie (si category est un nom)
        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND c.category_name = ? ");
            params.add(category);
        }

        // Filtre statut
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equals(status)) {
                sql.append("AND p.is_active = true ");
            } else if ("inactive".equals(status)) {
                sql.append("AND p.is_active = false ");
            }
        }

        sql.append("ORDER BY p.product_name LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
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
                    products.add(mapProductWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur pagination produits: " + e.getMessage());
            e.printStackTrace();
        }

        return products;
    }

    public long getTotalProductsCount(String search, String category, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM products p ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(p.product_name) LIKE LOWER(?) OR LOWER(p.generic_name) LIKE LOWER(?) OR p.barcode LIKE ?) ");
            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre catégorie
        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND c.category_name = ? ");
            params.add(category);
        }

        // Filtre statut
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equals(status)) {
                sql.append("AND p.is_active = true ");
            } else if ("inactive".equals(status)) {
                sql.append("AND p.is_active = false ");
            }
        }

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
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
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur comptage produits: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public long getActiveProductsCount() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = true";

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur comptage produits actifs: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public long getPrescriptionProductsCount() {
        String sql = "SELECT COUNT(*) FROM products WHERE requires_prescription = true AND is_active = true";

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur comptage produits sur ordonnance: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalInventoryValue() {
        String sql = "SELECT COALESCE(SUM(p.selling_price * COALESCE(i.quantity_in_stock, 0)), 0) " +
                "FROM products p " +
                "LEFT JOIN inventory i ON p.product_id = i.product_id " +
                "WHERE p.is_active = true";

        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur calcul valeur inventaire: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Product> getProductsByManufacturer(String manufacturer) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE p.manufacturer LIKE ? AND p.is_active = true ORDER BY p.product_name";

        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + manufacturer + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProductWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur recherche par fabricant: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public List<String> getAllManufacturers() {
        List<String> manufacturers = new ArrayList<>();
        String sql = "SELECT DISTINCT manufacturer FROM products WHERE manufacturer IS NOT NULL AND manufacturer != '' ORDER BY manufacturer";

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                manufacturers.add(rs.getString("manufacturer"));
            }
        } catch (SQLException e) {
            System.err.println("Erreur liste fabricants: " + e.getMessage());
            e.printStackTrace();
        }
        return manufacturers;
    }

    public List<String> getAllDosageForms() {
        List<String> forms = new ArrayList<>();
        String sql = "SELECT DISTINCT dosage_form FROM products WHERE dosage_form IS NOT NULL AND dosage_form != '' ORDER BY dosage_form";

        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                forms.add(rs.getString("dosage_form"));
            }
        } catch (SQLException e) {
            System.err.println("Erreur liste formes galéniques: " + e.getMessage());
            e.printStackTrace();
        }
        return forms;
    }

    // ========== HELPER METHODS ==========

    private void setProductParameters(PreparedStatement stmt, Product product) throws SQLException {
        stmt.setString(1, product.getProductName());
        stmt.setString(2, product.getGenericName());
        if (product.getCategoryId() != null) {
            stmt.setInt(3, product.getCategoryId());
        } else {
            stmt.setNull(3, Types.INTEGER);
        }
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

        // Nouvelles colonnes (si elles existent dans la table)
        if (columnExists(rs, "total_sold")) {
            product.setTotalSold(rs.getInt("total_sold"));
        }
        if (columnExists(rs, "total_revenue")) {
            product.setTotalRevenue(rs.getDouble("total_revenue"));
        }
        if (columnExists(rs, "last_sold_date")) {
            Timestamp lastSold = rs.getTimestamp("last_sold_date");
            product.setLastSoldDate(lastSold != null ? lastSold.toLocalDateTime() : null);
        }

        // Champ de jointure
        if (columnExists(rs, "category_name")) {
            product.setCategoryName(rs.getString("category_name"));
        }

        return product;
    }

    private boolean columnExists(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}