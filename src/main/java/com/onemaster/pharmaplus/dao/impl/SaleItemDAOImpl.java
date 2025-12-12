package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.SaleItemDAO;
import com.onemaster.pharmaplus.model.SaleItem;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class SaleItemDAOImpl implements SaleItemDAO {
    static final Logger logger = Logger.getLogger(SaleItemDAOImpl.class.getName());

    @Override
    public Integer insert(SaleItem saleItem) {
        String sql = "INSERT INTO sale_items (sale_id, product_id, inventory_id, " +
                "quantity, unit_price, discount, line_total) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setSaleItemParameters(stmt, saleItem);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        Integer generatedId = rs.getInt(1);
                        saleItem.setSaleItemId(generatedId);
                        return generatedId;
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion de l'item de vente: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public void update(SaleItem saleItem) {
        String sql = "UPDATE sale_items SET sale_id = ?, product_id = ?, inventory_id = ?, " +
                "quantity = ?, unit_price = ?, discount = ?, line_total = ? " +
                "WHERE sale_item_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            setSaleItemParameters(stmt, saleItem);
            stmt.setInt(8, saleItem.getSaleItemId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour de l'item de vente: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer saleItemId) {
        String sql = "DELETE FROM sale_items WHERE sale_item_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleItemId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression de l'item de vente: " + e.getMessage(), e);
        }
    }

    @Override
    public SaleItem findById(Integer saleItemId) {
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "WHERE si.sale_item_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleItemId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapSaleItemWithDetails(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de l'item de vente par ID: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public List<SaleItem> findAll() {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "ORDER BY si.sale_item_id DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                items.add(mapSaleItemWithDetails(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de tous les items de vente: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public List<SaleItem> findBySaleId(Integer saleId) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "WHERE si.sale_id = ? " +
                "ORDER BY si.sale_item_id";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des items de vente par ID de vente: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public List<SaleItem> findByProductId(Integer productId) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "WHERE si.product_id = ? " +
                "ORDER BY si.sale_item_id DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des items de vente par ID de produit: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public List<SaleItem> findByInventoryId(Integer inventoryId) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "WHERE si.inventory_id = ? " +
                "ORDER BY si.sale_item_id DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des items de vente par ID d'inventaire: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public Integer getTotalQuantitySoldByProduct(Integer productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM sale_items WHERE product_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul de la quantité vendue par produit: " + e.getMessage(), e);
        }

        return 0;
    }

    @Override
    public Double getTotalRevenueByProduct(Integer productId) {
        String sql = "SELECT COALESCE(SUM(line_total), 0) FROM sale_items WHERE product_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul du revenu total par produit: " + e.getMessage(), e);
        }

        return 0.0;
    }

    @Override
    public Integer getTotalItemsSoldForSale(Integer saleId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM sale_items WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul du nombre d'items vendus pour une vente: " + e.getMessage(), e);
        }

        return 0;
    }

    @Override
    public Double getTotalAmountForSale(Integer saleId) {
        String sql = "SELECT COALESCE(SUM(line_total), 0) FROM sale_items WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul du montant total pour une vente: " + e.getMessage(), e);
        }

        return 0.0;
    }

    @Override
    public void insertBatch(List<SaleItem> saleItems) {
        String sql = "INSERT INTO sale_items (sale_id, product_id, inventory_id, " +
                "quantity, unit_price, discount, line_total) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            for (SaleItem item : saleItems) {
                setSaleItemParameters(stmt, item);
                stmt.addBatch();
            }

            int[] results = stmt.executeBatch();

            // Récupérer les IDs générés
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                int index = 0;
                while (rs.next()) {
                    if (index < saleItems.size()) {
                        saleItems.get(index).setSaleItemId(rs.getInt(1));
                        index++;
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion en batch des items de vente: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteBySaleId(Integer saleId) {
        String sql = "DELETE FROM sale_items WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression des items de vente par ID de vente: " + e.getMessage(), e);
        }
    }

    @Override
    public List<SaleItem> findByBatchNumber(String batchNumber) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                "FROM sale_items si " +
                "LEFT JOIN products p ON si.product_id = p.product_id " +
                "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                "WHERE i.batch_number = ? " +
                "ORDER BY si.sale_item_id DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, batchNumber);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des items de vente par numéro de lot: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public List<Object[]> getProductSalesSummary(LocalDate start, LocalDate end) {
        List<Object[]> results = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, " +
                "SUM(si.quantity) as total_quantity, " +
                "SUM(si.line_total) as total_revenue, " +
                "AVG(si.unit_price) as avg_price " +
                "FROM sale_items si " +
                "JOIN sales s ON si.sale_id = s.sale_id " +
                "JOIN products p ON si.product_id = p.product_id " +
                "WHERE DATE(s.sale_date) BETWEEN ? AND ? " +
                "GROUP BY p.product_id, p.product_name " +
                "ORDER BY total_revenue DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[5];
                    row[0] = rs.getInt("product_id");
                    row[1] = rs.getString("product_name");
                    row[2] = rs.getInt("total_quantity");
                    row[3] = rs.getDouble("total_revenue");
                    row[4] = rs.getDouble("avg_price");
                    results.add(row);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la génération du résumé des ventes par produit: " + e.getMessage(), e);
        }

        return results;
    }

    @Override
    public List<SaleItem> findTopSellingItems(int limit) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.product_id, p.product_name, " +
                "SUM(si.quantity) as total_quantity, " +
                "SUM(si.line_total) as total_revenue " +
                "FROM sale_items si " +
                "JOIN products p ON si.product_id = p.product_id " +
                "GROUP BY si.product_id, p.product_name " +
                "ORDER BY total_quantity DESC " +
                "LIMIT ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = new SaleItem();
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("total_quantity"));
                    item.setLineTotal(rs.getDouble("total_revenue"));
                    items.add(item);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des items les plus vendus: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public Boolean existsByProductId(Integer productId) {
        String sql = "SELECT COUNT(*) FROM sale_items WHERE product_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification d'existence par ID de produit: " + e.getMessage(), e);
        }

        return false;
    }

    @Override
    public Boolean existsByInventoryId(Integer inventoryId) {
        String sql = "SELECT COUNT(*) FROM sale_items WHERE inventory_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification d'existence par ID d'inventaire: " + e.getMessage(), e);
        }

        return false;
    }

    @Override
    public List<SaleItem> findDetailedItemsBySaleId(Integer saleId) {
        return findBySaleId(saleId); // Cette méthode retourne déjà les détails
    }

    // ============================
    // MÉTHODES DE PAGINATION
    // ============================

    public List<SaleItem> getSaleItemsWithPagination(int offset, int limit,
                                                     Integer saleId, Integer productId, String batchNumber,
                                                     String startDate, String endDate) {

        List<SaleItem> items = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT si.*, p.product_name, i.batch_number, s.sale_date ")
                .append("FROM sale_items si ")
                .append("LEFT JOIN products p ON si.product_id = p.product_id ")
                .append("LEFT JOIN inventory i ON si.inventory_id = i.inventory_id ")
                .append("LEFT JOIN sales s ON si.sale_id = s.sale_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre par ID de vente
        if (saleId != null) {
            sql.append("AND si.sale_id = ? ");
            params.add(saleId);
        }

        // Filtre par ID de produit
        if (productId != null) {
            sql.append("AND si.product_id = ? ");
            params.add(productId);
        }

        // Filtre par numéro de lot
        if (batchNumber != null && !batchNumber.trim().isEmpty()) {
            sql.append("AND i.batch_number LIKE ? ");
            params.add("%" + batchNumber + "%");
        }

        // Filtre par date de début
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) >= ? ");
            params.add(Date.valueOf(startDate));
        }

        // Filtre par date de fin
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) <= ? ");
            params.add(Date.valueOf(endDate));
        }

        sql.append("ORDER BY si.sale_item_id DESC ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(limit);
        params.add(offset);

        // ✅ CORRECT: try-with-resources avec gestion des paramètres
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    stmt.setDate(i + 1, (Date) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = mapSaleItemWithDetails(rs);
                    items.add(item);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des items de vente: " + e.getMessage(), e);
        }

        return items;
    }

    public long getTotalSaleItemsCount(Integer saleId, Integer productId,
                                       String batchNumber, String startDate, String endDate) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM sale_items si ")
                .append("LEFT JOIN inventory i ON si.inventory_id = i.inventory_id ")
                .append("LEFT JOIN sales s ON si.sale_id = s.sale_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres
        if (saleId != null) {
            sql.append("AND si.sale_id = ? ");
            params.add(saleId);
        }

        if (productId != null) {
            sql.append("AND si.product_id = ? ");
            params.add(productId);
        }

        if (batchNumber != null && !batchNumber.trim().isEmpty()) {
            sql.append("AND i.batch_number LIKE ? ");
            params.add("%" + batchNumber + "%");
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) >= ? ");
            params.add(Date.valueOf(startDate));
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) <= ? ");
            params.add(Date.valueOf(endDate));
        }

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    stmt.setDate(i + 1, (Date) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des items de vente: " + e.getMessage(), e);
        }

        return 0;
    }

    // ============================
    // MÉTHODES UTILITAIRES
    // ============================

    private void setSaleItemParameters(PreparedStatement stmt, SaleItem saleItem) throws SQLException {
        stmt.setInt(1, saleItem.getSaleId());
        stmt.setInt(2, saleItem.getProductId());

        if (saleItem.getInventoryId() != null) {
            stmt.setInt(3, saleItem.getInventoryId());
        } else {
            stmt.setNull(3, Types.INTEGER);
        }

        stmt.setInt(4, saleItem.getQuantity());
        stmt.setDouble(5, saleItem.getUnitPrice());
        stmt.setDouble(6, saleItem.getDiscount() != null ? saleItem.getDiscount() : 0.0);
        stmt.setDouble(7, saleItem.getLineTotal());
    }

    private SaleItem mapSaleItemWithDetails(ResultSet rs) throws SQLException {
        SaleItem item = new SaleItem();
        item.setSaleItemId(rs.getInt("sale_item_id"));
        item.setSaleId(rs.getInt("sale_id"));
        item.setProductId(rs.getInt("product_id"));

        int inventoryId = rs.getInt("inventory_id");
        if (!rs.wasNull()) {
            item.setInventoryId(inventoryId);
        }

        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getDouble("unit_price"));
        item.setDiscount(rs.getDouble("discount"));
        item.setLineTotal(rs.getDouble("line_total"));

        // Champs de jointure
        item.setProductName(rs.getString("product_name"));
        item.setBatchNumber(rs.getString("batch_number"));

        return item;
    }
}