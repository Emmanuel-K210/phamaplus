package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.InventoryDAO;
import com.onemaster.pharmaplus.model.Inventory;
import com.onemaster.pharmaplus.utils.JdbcUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAOImpl implements InventoryDAO {

    // ============================
    // CRUD OPERATIONS - CORRIGÉES
    // ============================

    @Override
    public void insert(Inventory inventory) {
        String sql = "INSERT INTO inventory (product_id, batch_number, supplier_id, " +
                "quantity_in_stock, quantity_reserved, manufacturing_date, " +
                "expiry_date, purchase_price, selling_price, received_date, location) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            setInventoryParameters(stmt, inventory, false);
            stmt.executeUpdate();

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                inventory.setInventoryId(rs.getInt(1));
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors de l'insertion d'inventaire", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
    }

    @Override
    public void update(Inventory inventory) {
        String sql = "UPDATE inventory SET product_id = ?, batch_number = ?, supplier_id = ?, " +
                "quantity_in_stock = ?, quantity_reserved = ?, manufacturing_date = ?, " +
                "expiry_date = ?, purchase_price = ?, selling_price = ?, received_date = ?, " +
                "location = ?, updated_at = NOW() " +
                "WHERE inventory_id = ?";

        Connection connection = null;
        PreparedStatement stmt = null;
        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            setInventoryParameters(stmt, inventory, true);
            stmt.executeUpdate();
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la mise à jour d'inventaire", e);
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    @Override
    public void delete(Integer inventoryId) {
        String sql = "DELETE FROM inventory WHERE inventory_id = ?";

        Connection connection = null;
        PreparedStatement stmt = null;

        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, inventoryId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 0) {
                System.err.println("Aucun inventaire trouvé avec l'ID: " + inventoryId);
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la suppression d'inventaire", e);
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    // ============================
    // FIND OPERATIONS
    // ============================

    @Override
    public Inventory findById(Integer inventoryId) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.inventory_id = ?";

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, inventoryId);

            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapInventory(rs);
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors de la recherche d'inventaire par ID", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return null;
    }

    @Override
    public List<Inventory> findAll() {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.quantity_in_stock >= 0 " +
                "ORDER BY i.expiry_date, p.product_name";

        return findByQuery(sql);
    }

    // ============================
// PAGINATION WITH FILTERS
// ============================

    @Override
    public List<Inventory> getInventoryWithPagination(int offset, int limit, String search,
                                                      String category, String status, String stockStatus, String expiryStatus) {

        List<Inventory> inventoryList = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.*, p.product_name, p.generic_name, p.barcode, ")
                .append("c.category_name, s.supplier_name, ")
                .append("(i.expiry_date < CURRENT_DATE) AS is_expired ")
                .append("FROM inventory i ")
                .append("JOIN products p ON i.product_id = p.product_id ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche (produit, batch, fournisseur)
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(p.product_name) LIKE LOWER(?) ")
                    .append("OR LOWER(p.generic_name) LIKE LOWER(?) ")
                    .append("OR LOWER(i.batch_number) LIKE LOWER(?) ")
                    .append("OR p.barcode LIKE ? ")
                    .append("OR LOWER(s.supplier_name) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre catégorie
        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND c.category_name = ? ");
            params.add(category);
        }

        // Filtre statut du produit (actif/inactif)
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append("AND p.is_active = true ");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append("AND p.is_active = false ");
            }
        }

        // Filtre statut du stock (en stock/rupture)
        if (stockStatus != null && !stockStatus.trim().isEmpty()) {
            if ("instock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock > 0 ");
            } else if ("outofstock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock <= 0 ");
            } else if ("lowstock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock > 0 AND i.quantity_in_stock <= p.low_stock_threshold ");
            }
        }

        // Filtre statut d'expiration
        if (expiryStatus != null && !expiryStatus.trim().isEmpty()) {
            switch (expiryStatus.toLowerCase()) {
                case "expired":
                    sql.append("AND i.expiry_date < CURRENT_DATE ");
                    break;
                case "expiring":
                    sql.append("AND i.expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days' ");
                    break;
                case "valid":
                    sql.append("AND i.expiry_date >= CURRENT_DATE ");
                    break;
            }
        }

        sql.append("ORDER BY i.expiry_date ASC, p.product_name ASC ");
        sql.append("LIMIT ? OFFSET ?");

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
                    inventoryList.add(mapInventory(rs));
                }
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors de la pagination d'inventaire", e);
            System.err.println("SQL: " + sql.toString());
        }

        return inventoryList;
    }

    @Override
    public long getTotalInventoryCount(String search, String category, String status,
                                       String stockStatus, String expiryStatus) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
                .append("FROM inventory i ")
                .append("JOIN products p ON i.product_id = p.product_id ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres que la méthode de pagination
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(p.product_name) LIKE LOWER(?) ")
                    .append("OR LOWER(p.generic_name) LIKE LOWER(?) ")
                    .append("OR LOWER(i.batch_number) LIKE LOWER(?) ")
                    .append("OR p.barcode LIKE ? ")
                    .append("OR LOWER(s.supplier_name) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND c.category_name = ? ");
            params.add(category);
        }

        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append("AND p.is_active = true ");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append("AND p.is_active = false ");
            }
        }

        if (stockStatus != null && !stockStatus.trim().isEmpty()) {
            if ("instock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock > 0 ");
            } else if ("outofstock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock <= 0 ");
            } else if ("lowstock".equalsIgnoreCase(stockStatus)) {
                sql.append("AND i.quantity_in_stock > 0 AND i.quantity_in_stock <= p.low_stock_threshold ");
            }
        }

        if (expiryStatus != null && !expiryStatus.trim().isEmpty()) {
            switch (expiryStatus.toLowerCase()) {
                case "expired":
                    sql.append("AND i.expiry_date < CURRENT_DATE ");
                    break;
                case "expiring":
                    sql.append("AND i.expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days' ");
                    break;
                case "valid":
                    sql.append("AND i.expiry_date >= CURRENT_DATE ");
                    break;
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
            handleSQLException("Erreur lors du comptage total d'inventaire", e);
        }

        return 0;
    }

    @Override
    public List<Inventory> findByProductId(Integer productId) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.product_id = ? AND i.quantity_in_stock > 0 " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql, productId);
    }

    @Override
    public List<Inventory> findExpired() {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "TRUE AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.expiry_date < CURRENT_DATE AND i.quantity_in_stock > 0 " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql);
    }

    @Override
    public List<Inventory> findExpiringSoon(int days) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + ? " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql, days);
    }

    @Override
    public List<Inventory> findByBatchNumber(String batchNumber) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.batch_number ILIKE ? " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql, "%" + batchNumber + "%");
    }

    @Override
    public List<Inventory> findBySupplierId(Integer supplierId) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.supplier_id = ? " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql, supplierId);
    }

    @Override
    public Inventory findByProductAndBatch(Integer productId, String batchNumber) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.product_id = ? AND i.batch_number = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setString(2, batchNumber);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapInventory(rs);
                }
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la recherche produit/batch", e);
        }
        return null;
    }

    @Override
    public List<Inventory> findLowStock(int threshold) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.quantity_in_stock <= ? AND i.quantity_in_stock > 0 " +
                "ORDER BY i.quantity_in_stock";

        return findByQuery(sql, threshold);
    }

    @Override
    public List<Inventory> findByLocation(String location) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.location ILIKE ? " +
                "ORDER BY i.location";

        return findByQuery(sql, "%" + location + "%");
    }

    @Override
    public List<Inventory> findByExpiryDateRange(LocalDate start, LocalDate end) {
        String sql = "SELECT i.*, p.product_name, p.generic_name, s.supplier_name, " +
                "(i.expiry_date < CURRENT_DATE) AS is_expired " +
                "FROM inventory i " +
                "JOIN products p ON i.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id " +
                "WHERE i.expiry_date BETWEEN ? AND ? " +
                "ORDER BY i.expiry_date";

        return findByQuery(sql, Date.valueOf(start), Date.valueOf(end));
    }

    // ============================
    // STOCK OPERATIONS
    // ============================

    @Override
    public int getTotalStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(i.quantity_in_stock), 0) " +
                "FROM inventory i " +
                "WHERE i.product_id = ? AND i.expiry_date >= CURRENT_DATE";

        return getStockSum(sql, productId);
    }

    @Override
    public int getAvailableStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) " +
                "FROM inventory i " +
                "WHERE i.product_id = ? AND i.expiry_date >= CURRENT_DATE";

        return getStockSum(sql, productId);
    }

    @Override
    public int getReservedStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(i.quantity_reserved), 0) " +
                "FROM inventory i " +
                "WHERE i.product_id = ? AND i.expiry_date >= CURRENT_DATE";

        return getStockSum(sql, productId);
    }

    @Override
    public boolean reserveStock(Integer inventoryId, Integer quantity) {
        String sql = "UPDATE inventory " +
                "SET quantity_reserved = quantity_reserved + ?, updated_at = NOW() " +
                "WHERE inventory_id = ? AND (quantity_in_stock - quantity_reserved) >= ?";

        return updateStock(sql, quantity, inventoryId, quantity);
    }

    @Override
    public boolean releaseStock(Integer inventoryId, Integer quantity) {
        String sql = "UPDATE inventory " +
                "SET quantity_reserved = quantity_reserved - ?, updated_at = NOW() " +
                "WHERE inventory_id = ? AND quantity_reserved >= ?";

        return updateStock(sql, quantity, inventoryId, quantity);
    }

    @Override
    public boolean consumeStock(Integer inventoryId, Integer quantity) {
        String sql = "UPDATE inventory " +
                "SET quantity_in_stock = quantity_in_stock - ?, " +
                "quantity_reserved = GREATEST(0, quantity_reserved - ?), " +
                "updated_at = NOW() " +
                "WHERE inventory_id = ? " +
                "AND quantity_in_stock >= ?";

        return updateStock(sql, quantity, quantity, inventoryId, quantity);
    }

    @Override
    public void updateExpiryStatus() {
        System.out.println("Le statut d'expiration est maintenant calculé dynamiquement dans les requêtes");
    }

    // ============================
    // HELPER METHODS - CORRIGÉES
    // ============================

    private void setInventoryParameters(PreparedStatement stmt, Inventory inventory, boolean isUpdate) throws SQLException {
        int paramIndex = 1;

        stmt.setInt(paramIndex++, inventory.getProductId());
        stmt.setString(paramIndex++, inventory.getBatchNumber());

        if (inventory.getSupplierId() != null) {
            stmt.setInt(paramIndex++, inventory.getSupplierId());
        } else {
            stmt.setNull(paramIndex++, Types.INTEGER);
        }

        stmt.setInt(paramIndex++, inventory.getQuantityInStock());
        stmt.setInt(paramIndex++, inventory.getQuantityReserved());

        if (inventory.getManufacturingDate() != null) {
            stmt.setDate(paramIndex++, Date.valueOf(inventory.getManufacturingDate()));
        } else {
            stmt.setNull(paramIndex++, Types.DATE);
        }

        stmt.setDate(paramIndex++, Date.valueOf(inventory.getExpiryDate()));

        if (inventory.getPurchasePrice() != null) {
            stmt.setDouble(paramIndex++, inventory.getPurchasePrice());
        } else {
            stmt.setNull(paramIndex++, Types.DECIMAL);
        }

        // Vérification du sellingPrice
        if (inventory.getSellingPrice() != null) {
            stmt.setDouble(paramIndex++, inventory.getSellingPrice());
        } else {
            // Si sellingPrice est null, mettez-le à null
            stmt.setNull(paramIndex++, Types.DECIMAL);
        }

        if (inventory.getReceivedDate() != null) {
            stmt.setDate(paramIndex++, Date.valueOf(inventory.getReceivedDate()));
        } else {
            stmt.setNull(paramIndex++, Types.DATE);
        }

        stmt.setString(paramIndex++, inventory.getLocation());

        // Pour l'update, ajouter l'ID à la fin
        if (isUpdate) {
            stmt.setInt(paramIndex, inventory.getInventoryId());
        }
    }

    private Inventory mapInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();

        inventory.setInventoryId(rs.getInt("inventory_id"));
        inventory.setProductId(rs.getInt("product_id"));
        inventory.setBatchNumber(rs.getString("batch_number"));

        int supplierId = rs.getInt("supplier_id");
        inventory.setSupplierId(rs.wasNull() ? null : supplierId);

        inventory.setQuantityInStock(rs.getInt("quantity_in_stock"));
        inventory.setQuantityReserved(rs.getInt("quantity_reserved"));

        Date manufacturingDate = rs.getDate("manufacturing_date");
        inventory.setManufacturingDate(manufacturingDate != null ? manufacturingDate.toLocalDate() : null);

        Date expiryDate = rs.getDate("expiry_date");
        if (expiryDate != null) {
            inventory.setExpiryDate(expiryDate.toLocalDate());
        }

        double purchasePrice = rs.getDouble("purchase_price");
        inventory.setPurchasePrice(rs.wasNull() ? null : purchasePrice);

        // Récupération du sellingPrice
        double sellingPrice = rs.getDouble("selling_price");
        inventory.setSellingPrice(rs.wasNull() ? null : sellingPrice);

        Date receivedDate = rs.getDate("received_date");
        inventory.setReceivedDate(receivedDate != null ? receivedDate.toLocalDate() : null);

        inventory.setLocation(rs.getString("location"));
        inventory.setIsExpired(rs.getBoolean("is_expired"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        inventory.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        inventory.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);

        // Infos supplémentaires
        inventory.setProductName(rs.getString("product_name"));
        inventory.setGenericName(rs.getString("generic_name"));
        inventory.setSupplierName(rs.getString("supplier_name"));

        return inventory;
    }

    private List<Inventory> findByQuery(String sql, Object... params) {
        List<Inventory> list = new ArrayList<>();

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapInventory(rs));
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors de l'exécution de la requête", e);
            System.err.println("Requête SQL en erreur: " + sql);
            for (int i = 0; i < params.length; i++) {
                System.err.println("Paramètre " + (i + 1) + ": " + params[i]);
            }
        } finally {
            JdbcUtil.close(rs, stmt);
        }

        return list;
    }

    private boolean updateStock(String sql, Object... params) {
        Connection connection = null;
        PreparedStatement stmt = null;
        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            handleSQLException("Erreur lors de la mise à jour du stock", e);
            return false;
        } finally {
            JdbcUtil.close(stmt);
        }
    }

    private int getStockSum(String sql, Object... params) {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DatabaseConnection.getConnection();
            stmt = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors du calcul du stock", e);
        } finally {
            JdbcUtil.close(rs, stmt);
        }

        return 0;
    }

    private void handleSQLException(String message, SQLException e) {
        System.err.println(message + ": " + e.getMessage());
        System.err.println("Code d'erreur SQL: " + e.getErrorCode());
        System.err.println("État SQL: " + e.getSQLState());

        if (e.getErrorCode() == 0 && e.getSQLState() == null) {
            System.err.println("Note: L'erreur provient probablement d'une requête préparée avec des paramètres incorrects.");
            System.err.println("Vérifiez que le nombre de '?' dans la requête correspond au nombre de paramètres fournis.");
        }

        e.printStackTrace();
    }
}