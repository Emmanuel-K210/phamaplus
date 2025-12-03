package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.InventoryDAO;
import com.onemaster.pharmaplus.model.Inventory;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAOImpl implements InventoryDAO {

    private final Connection connection;

    public InventoryDAOImpl() {
        this.connection = DatabaseConnection.getConnection();
    }

    // ============================
    // CRUD OPERATIONS
    // ============================

    @Override
    public void insert(Inventory inventory) {
        String sql = "INSERT INTO inventory (product_id, batch_number, supplier_id, " +
                "quantity_in_stock, quantity_reserved, manufacturing_date, " +
                "expiry_date, purchase_price, received_date, location) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setInventoryParameters(stmt, inventory);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    inventory.setInventoryId(rs.getInt(1));
                }
            }

        } catch (SQLException e) {
            handleSQLException("Erreur lors de l'insertion d'inventaire", e);
        }
    }

    @Override
    public void update(Inventory inventory) {
        String sql = "UPDATE inventory SET product_id = ?, batch_number = ?, supplier_id = ?, " +
                "quantity_in_stock = ?, quantity_reserved = ?, manufacturing_date = ?, " +
                "expiry_date = ?, purchase_price = ?, received_date = ?, location = ?, updated_at = NOW() " +
                "WHERE inventory_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            setInventoryParameters(stmt, inventory);
            stmt.setInt(11, inventory.getInventoryId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la mise à jour d'inventaire", e);
        }
    }

    @Override
    public void delete(Integer inventoryId) {
        String sql = "DELETE FROM inventory WHERE inventory_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 0) {
                System.err.println("Aucun inventaire trouvé avec l'ID: " + inventoryId);
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la suppression d'inventaire", e);
        }
    }

    // ============================
    // FIND OPERATIONS
    // ============================

    @Override
    public Inventory findById(Integer inventoryId) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE inventory_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapInventory(rs);
                }
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors de la recherche d'inventaire par ID", e);
        }
        return null;
    }

    @Override
    public List<Inventory> findAll() {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE quantity_in_stock > 0 " +
                "ORDER BY expiry_date, product_name";

        return findByQuery(sql);
    }

    @Override
    public List<Inventory> findByProductId(Integer productId) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE product_id = ? AND quantity_in_stock > 0 " +
                "ORDER BY expiry_date";

        return findByQuery(sql, productId);
    }

    @Override
    public List<Inventory> findExpired() {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE is_expired = TRUE " +
                "ORDER BY expiry_date";

        return findByQuery(sql);
    }

    @Override
    public List<Inventory> findExpiringSoon(int days) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + ? " +
                "ORDER BY expiry_date";

        return findByQuery(sql, days);
    }

    @Override
    public List<Inventory> findByBatchNumber(String batchNumber) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE batch_number ILIKE ? " +
                "ORDER BY expiry_date";

        return findByQuery(sql, "%" + batchNumber + "%");
    }

    @Override
    public List<Inventory> findBySupplierId(Integer supplierId) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE supplier_id = ? " +
                "ORDER BY expiry_date";

        return findByQuery(sql, supplierId);
    }

    @Override
    public Inventory findByProductAndBatch(Integer productId, String batchNumber) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE product_id = ? AND batch_number = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
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
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE quantity_in_stock <= ? AND quantity_in_stock > 0 " +
                "ORDER BY quantity_in_stock";

        return findByQuery(sql, threshold);
    }

    @Override
    public List<Inventory> findByLocation(String location) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE location ILIKE ? " +
                "ORDER BY location";

        return findByQuery(sql, "%" + location + "%");
    }

    @Override
    public List<Inventory> findByExpiryDateRange(LocalDate start, LocalDate end) {
        String sql = "SELECT v_inventory.*, p.product_name, s.supplier_name " +
                "FROM v_inventory " +
                "JOIN products p ON v_inventory.product_id = p.product_id " +
                "LEFT JOIN suppliers s ON v_inventory.supplier_id = s.supplier_id " +
                "WHERE expiry_date BETWEEN ? AND ? " +
                "ORDER BY expiry_date";

        return findByQuery(sql, Date.valueOf(start), Date.valueOf(end));
    }

    // ============================
    // STOCK OPERATIONS
    // ============================

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
                "quantity_reserved = quantity_reserved - ?, " +
                "updated_at = NOW() " +
                "WHERE inventory_id = ? " +
                "AND quantity_in_stock >= ? " +
                "AND quantity_reserved >= ?";

        return updateStock(sql, quantity, quantity, inventoryId, quantity, quantity);
    }

    @Override
    public int getTotalStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(quantity_in_stock), 0) " +
                "FROM v_inventory " +
                "WHERE product_id = ? AND is_expired = FALSE";

        return getStockSum(sql, productId);
    }

    @Override
    public int getAvailableStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(quantity_in_stock - quantity_reserved), 0) " +
                "FROM v_inventory " +
                "WHERE product_id = ? AND is_expired = FALSE";

        return getStockSum(sql, productId);
    }

    @Override
    public int getReservedStockQuantity(Integer productId) {
        String sql = "SELECT COALESCE(SUM(quantity_reserved), 0) " +
                "FROM v_inventory " +
                "WHERE product_id = ? AND is_expired = FALSE";

        return getStockSum(sql, productId);
    }

    @Override
    public void updateExpiryStatus() {
        System.out.println("Le statut d'expiration est maintenant géré automatiquement via la vue v_inventory");
    }

    // ============================
    // HELPER METHODS
    // ============================

    private void setInventoryParameters(PreparedStatement stmt, Inventory inventory) throws SQLException {
        stmt.setInt(1, inventory.getProductId());
        stmt.setString(2, inventory.getBatchNumber());

        if (inventory.getSupplierId() != null) {
            stmt.setInt(3, inventory.getSupplierId());
        } else {
            stmt.setNull(3, Types.INTEGER);
        }

        stmt.setInt(4, inventory.getQuantityInStock());
        stmt.setInt(5, inventory.getQuantityReserved());

        if (inventory.getManufacturingDate() != null) {
            stmt.setDate(6, Date.valueOf(inventory.getManufacturingDate()));
        } else {
            stmt.setNull(6, Types.DATE);
        }

        stmt.setDate(7, Date.valueOf(inventory.getExpiryDate()));

        if (inventory.getPurchasePrice() != null) {
            stmt.setDouble(8, inventory.getPurchasePrice());
        } else {
            stmt.setNull(8, Types.DECIMAL);
        }

        if (inventory.getReceivedDate() != null) {
            stmt.setDate(9, Date.valueOf(inventory.getReceivedDate()));
        } else {
            stmt.setNull(9, Types.DATE);
        }

        stmt.setString(10, inventory.getLocation());
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

        Date receivedDate = rs.getDate("received_date");
        inventory.setReceivedDate(receivedDate != null ? receivedDate.toLocalDate() : null);

        inventory.setLocation(rs.getString("location"));
        inventory.setIsExpired(rs.getBoolean("is_expired"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        inventory.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        inventory.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);

        inventory.setProductName(rs.getString("product_name"));
        inventory.setSupplierName(rs.getString("supplier_name"));

        return inventory;
    }

    private List<Inventory> findByQuery(String sql, Object... params) {
        List<Inventory> list = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInventory(rs));
                }
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors de l'exécution de la requête", e);
        }

        return list;
    }

    private boolean updateStock(String sql, Object... params) {
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            handleSQLException("Erreur lors de la mise à jour du stock", e);
            return false;
        }
    }

    private int getStockSum(String sql, Object... params) {
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            handleSQLException("Erreur lors du calcul du stock", e);
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