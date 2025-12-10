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
            logger.severe("Erreur lors de l'insertion de l'item de vente: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void update(SaleItem saleItem) {
        String sql = "UPDATE sale_items SET sale_id = ?, product_id = ?, inventory_id = ?, " +
                     "quantity = ?, unit_price = ?, discount = ?, line_total = ? " +
                     "WHERE sale_item_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            setSaleItemParameters(stmt, saleItem);
            stmt.setInt(8, saleItem.getSaleItemId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.severe("Erreur lors de la mise à jour de l'item de vente: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Integer saleItemId) {
        String sql = "DELETE FROM sale_items WHERE sale_item_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleItemId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.severe("Erreur lors de la suppression de l'item de vente: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public SaleItem findById(Integer saleItemId) {
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                     "FROM sale_items si " +
                     "LEFT JOIN products p ON si.product_id = p.product_id " +
                     "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                     "WHERE si.sale_item_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleItemId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapSaleItemWithDetails(rs);
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la recherche de l'item de vente: " + e.getMessage());
            e.printStackTrace();
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

        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                items.add(mapSaleItemWithDetails(rs));
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la récupération de tous les items: " + e.getMessage());
            e.printStackTrace();
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

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la recherche des items par vente: " + e.getMessage());
            e.printStackTrace();
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
                     "ORDER BY si.sale_date DESC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la recherche des items par produit: " + e.getMessage());
            e.printStackTrace();
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

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, inventoryId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la recherche des items par inventaire: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public Integer getTotalQuantitySoldByProduct(Integer productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM sale_items WHERE product_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors du calcul de la quantité vendue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Double getTotalRevenueByProduct(Integer productId) {
        String sql = "SELECT COALESCE(SUM(line_total), 0) FROM sale_items WHERE product_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors du calcul du revenu par produit: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public Integer getTotalItemsSoldForSale(Integer saleId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM sale_items WHERE sale_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors du calcul des items vendus pour la vente: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Double getTotalAmountForSale(Integer saleId) {
        String sql = "SELECT COALESCE(SUM(line_total), 0) FROM sale_items WHERE sale_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors du calcul du montant total pour la vente: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public void insertBatch(List<SaleItem> saleItems) {
        String sql = "INSERT INTO sale_items (sale_id, product_id, inventory_id, " +
                     "quantity, unit_price, discount, line_total) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

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
            logger.severe("Erreur lors de l'insertion en batch des items: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void deleteBySaleId(Integer saleId) {
        String sql = "DELETE FROM sale_items WHERE sale_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, saleId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.severe("Erreur lors de la suppression des items par vente: " + e.getMessage());
            e.printStackTrace();
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

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setString(1, batchNumber);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la recherche par numéro de lot: " + e.getMessage());
            e.printStackTrace();
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
            logger.severe("Erreur lors du résumé des ventes par produit: " + e.getMessage());
            e.printStackTrace();
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
            logger.severe("Erreur lors de la recherche des meilleures ventes: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public Boolean existsByProductId(Integer productId) {
        String sql = "SELECT COUNT(*) FROM sale_items WHERE product_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la vérification d'existence par produit: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Boolean existsByInventoryId(Integer inventoryId) {
        String sql = "SELECT COUNT(*) FROM sale_items WHERE inventory_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            stmt.setInt(1, inventoryId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.severe("Erreur lors de la vérification d'existence par inventaire: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<SaleItem> findDetailedItemsBySaleId(Integer saleId) {
        return findBySaleId(saleId); // Cette méthode retourne déjà les détails
    }

    // ========== HELPER METHODS ==========

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