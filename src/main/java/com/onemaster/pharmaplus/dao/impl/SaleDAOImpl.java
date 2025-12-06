package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleItem;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SaleDAOImpl implements SaleDAO {
    

    @Override
    public Integer insertSale(Sale sale) {
        String sql = "INSERT INTO sales (customer_id, prescription_id, sale_date, " +
                     "subtotal, discount_amount, tax_amount, total_amount, " +
                     "payment_method, payment_status, served_by, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setSaleParameters(stmt, sale);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Retourne le sale_id généré
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur insertion vente: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public void updateSale(Sale sale) {
        String sql = "UPDATE sales SET customer_id = ?, prescription_id = ?, " +
                     "subtotal = ?, discount_amount = ?, tax_amount = ?, " +
                     "total_amount = ?, payment_method = ?, payment_status = ?, " +
                     "served_by = ?, notes = ? WHERE sale_id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            setSaleParameters(stmt, sale);
            stmt.setInt(11, sale.getSaleId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur mise à jour vente: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void deleteSale(Integer saleId) {
        // D'abord supprimer les items
        deleteSaleItems(saleId);
        
        String sql = "DELETE FROM sales WHERE sale_id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, saleId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur suppression vente: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public Sale findSaleById(Integer saleId) {
        String sql = "SELECT s.*, c.first_name, c.last_name " +
                     "FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE s.sale_id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, saleId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapSaleWithCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur recherche vente par ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public List<Sale> findAllSales() {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name " +
                     "FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "ORDER BY s.sale_date DESC";
        
        try (
                Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                sales.add(mapSaleWithCustomer(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur récupération ventes: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }
    
    @Override
    public void insertSaleItem(SaleItem saleItem) {
        String sql = "INSERT INTO sale_items (sale_id, product_id, inventory_id, " +
                     "quantity, unit_price, discount, line_total) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, saleItem.getSaleId());
            stmt.setInt(2, saleItem.getProductId());
            stmt.setInt(3, saleItem.getInventoryId());
            stmt.setInt(4, saleItem.getQuantity());
            stmt.setDouble(5, saleItem.getUnitPrice());
            stmt.setDouble(6, saleItem.getDiscount() != null ? saleItem.getDiscount() : 0.0);
            stmt.setDouble(7, saleItem.getLineTotal());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur insertion item vente: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public List<SaleItem> findItemsBySaleId(Integer saleId) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.product_name, i.batch_number " +
                     "FROM sale_items si " +
                     "JOIN products p ON si.product_id = p.product_id " +
                     "LEFT JOIN inventory i ON si.inventory_id = i.inventory_id " +
                     "WHERE si.sale_id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, saleId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapSaleItemWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur récupération items vente: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }
    
    @Override
    public void deleteSaleItems(Integer saleId) {
        String sql = "DELETE FROM sale_items WHERE sale_id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, saleId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur suppression items vente: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public List<Sale> findSalesByCustomer(Integer customerId) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE s.customer_id = ? ORDER BY s.sale_date DESC";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur recherche ventes par client: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }
    
    @Override
    public List<Sale> findSalesByDate(LocalDate date) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE DATE(s.sale_date) = ? ORDER BY s.sale_date DESC";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(date));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur recherche ventes par date: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }
    
    @Override
    public Double getTotalRevenue(LocalDate start, LocalDate end) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM sales " +
                     "WHERE DATE(sale_date) BETWEEN ? AND ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur calcul revenu total: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    
    @Override
    public Integer getTotalItemsSold(LocalDate start, LocalDate end) {
        String sql = "SELECT COALESCE(SUM(si.quantity), 0) " +
                     "FROM sales s " +
                     "JOIN sale_items si ON s.sale_id = si.sale_id " +
                     "WHERE DATE(s.sale_date) BETWEEN ? AND ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur calcul items vendus: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    @Override
    public List<Object[]> getTopSellingProducts(int limit) {
        List<Object[]> results = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, " +
                     "SUM(si.quantity) as total_quantity, " +
                     "SUM(si.line_total) as total_revenue " +
                     "FROM sale_items si " +
                     "JOIN products p ON si.product_id = p.product_id " +
                     "GROUP BY p.product_id, p.product_name " +
                     "ORDER BY total_quantity DESC " +
                     "LIMIT ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[4];
                    row[0] = rs.getInt("product_id");
                    row[1] = rs.getString("product_name");
                    row[2] = rs.getInt("total_quantity");
                    row[3] = rs.getDouble("total_revenue");
                    results.add(row);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur top produits: " + e.getMessage());
            e.printStackTrace();
        }
        return results;
    }
    
    @Override
    public Double getTodayRevenue() {
        return getTotalRevenue(LocalDate.now(), LocalDate.now());
    }
    
    @Override
    public Integer getTodayTransactions() {
        String sql = "SELECT COUNT(*) FROM sales WHERE DATE(sale_date) = CURRENT_DATE";
        
        try (Connection connection = DatabaseConnection.getConnection();
                Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur transactions aujourd'hui: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    @Override
    public List<Sale> getRecentSales(int limit) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "ORDER BY s.sale_date DESC LIMIT ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur ventes récentes: " + e.getMessage());
            e.printStackTrace();
        }
        return sales;
    }
    
    // ========== HELPER METHODS ==========
    
    private void setSaleParameters(PreparedStatement stmt, Sale sale) throws SQLException {
        if (sale.getCustomerId() != null) {
            stmt.setInt(1, sale.getCustomerId());
        } else {
            stmt.setNull(1, Types.INTEGER);
        }
        
        if (sale.getPrescriptionId() != null) {
            stmt.setInt(2, sale.getPrescriptionId());
        } else {
            stmt.setNull(2, Types.INTEGER);
        }
        
        stmt.setTimestamp(3, Timestamp.valueOf(sale.getSaleDate()));
        stmt.setDouble(4, sale.getSubtotal());
        stmt.setDouble(5, sale.getDiscountAmount());
        stmt.setDouble(6, sale.getTaxAmount());
        stmt.setDouble(7, sale.getTotalAmount());
        stmt.setString(8, sale.getPaymentMethod());
        stmt.setString(9, sale.getPaymentStatus());
        stmt.setString(10, sale.getServedBy());
        stmt.setString(11, sale.getNotes());
    }
    
    private Sale mapSaleWithCustomer(ResultSet rs) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(rs.getInt("sale_id"));
        
        int customerId = rs.getInt("customer_id");
        if (!rs.wasNull()) {
            sale.setCustomerId(customerId);
        }
        
        int prescriptionId = rs.getInt("prescription_id");
        if (!rs.wasNull()) {
            sale.setPrescriptionId(prescriptionId);
        }
        
        sale.setSaleDate(rs.getTimestamp("sale_date").toLocalDateTime());
        sale.setSubtotal(rs.getDouble("subtotal"));
        sale.setDiscountAmount(rs.getDouble("discount_amount"));
        sale.setTaxAmount(rs.getDouble("tax_amount"));
        sale.setTotalAmount(rs.getDouble("total_amount"));
        sale.setPaymentMethod(rs.getString("payment_method"));
        sale.setPaymentStatus(rs.getString("payment_status"));
        sale.setServedBy(rs.getString("served_by"));
        sale.setNotes(rs.getString("notes"));
        
        // Champs de jointure
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        if (firstName != null && lastName != null) {
            sale.setCustomerName(firstName + " " + lastName);
        }
        
        return sale;
    }
    
    private SaleItem mapSaleItemWithDetails(ResultSet rs) throws SQLException {
        SaleItem item = new SaleItem();
        item.setSaleItemId(rs.getInt("sale_item_id"));
        item.setSaleId(rs.getInt("sale_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setInventoryId(rs.getInt("inventory_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getDouble("unit_price"));
        item.setDiscount(rs.getDouble("discount"));
        item.setLineTotal(rs.getDouble("line_total"));
        
        // Champs de jointure
        item.setProductName(rs.getString("product_name"));
        item.setBatchNumber(rs.getString("batch_number"));
        
        return item;
    }

    // Méthodes restantes à implémenter
    @Override
    public List<Sale> findSalesByDateRange(LocalDate start, LocalDate end) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE DATE(s.sale_date) BETWEEN ? AND ? " +
                     "ORDER BY s.sale_date DESC";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
    }

    @Override
    public List<Sale> findSalesByPaymentMethod(String paymentMethod) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE s.payment_method = ? ORDER BY s.sale_date DESC";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, paymentMethod);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
    }

    @Override
    public List<Sale> findSalesByPrescription(Integer prescriptionId) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                     "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                     "WHERE s.prescription_id = ? ORDER BY s.sale_date DESC";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, prescriptionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
    }

    @Override
    public Integer getTotalTransactions(LocalDate start, LocalDate end) {
        String sql = "SELECT COUNT(*) FROM sales " +
                     "WHERE DATE(sale_date) BETWEEN ? AND ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Object[]> getDailySales(LocalDate start, LocalDate end) {
        List<Object[]> results = new ArrayList<>();
        String sql = "SELECT DATE(sale_date) as sale_day, " +
                     "COUNT(*) as transactions, " +
                     "SUM(total_amount) as revenue, " +
                     "SUM(quantity) as items_sold " +
                     "FROM sales s " +
                     "LEFT JOIN sale_items si ON s.sale_id = si.sale_id " +
                     "WHERE DATE(s.sale_date) BETWEEN ? AND ? " +
                     "GROUP BY DATE(sale_date) " +
                     "ORDER BY sale_day";
        
        try (Connection connection = DatabaseConnection.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(start));
            stmt.setDate(2, Date.valueOf(end));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[4];
                    row[0] = rs.getDate("sale_day").toLocalDate();
                    row[1] = rs.getInt("transactions");
                    row[2] = rs.getDouble("revenue");
                    row[3] = rs.getInt("items_sold");
                    results.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
}