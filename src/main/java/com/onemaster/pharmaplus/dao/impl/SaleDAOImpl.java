package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleItem;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class SaleDAOImpl implements SaleDAO {
    static final Logger logger = Logger.getLogger(SaleDAOImpl.class.getName());

    @Override
    public Integer insertSale(Sale sale) {
        String sql = "INSERT INTO sales (customer_id, prescription_id, sale_date, " +
                "subtotal, discount_amount, tax_amount, total_amount, " +
                "payment_method, payment_status, served_by, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors de l'insertion de la vente: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public void updateSale(Sale sale) {
        String sql = "UPDATE sales SET customer_id = ?, prescription_id = ?, " +
                "subtotal = ?, discount_amount = ?, tax_amount = ?, " +
                "total_amount = ?, payment_method = ?, payment_status = ?, " +
                "served_by = ?, notes = ?, updated_at = NOW() WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            setSaleParameters(stmt, sale);
            stmt.setInt(11, sale.getSaleId());

            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour de la vente: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteSale(Integer saleId) {
        // D'abord supprimer les items
        deleteSaleItems(saleId);

        String sql = "DELETE FROM sales WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression de la vente: " + e.getMessage(), e);
        }
    }

    @Override
    public Sale findSaleById(Integer saleId) {
        String sql = "SELECT s.*, c.first_name, c.last_name " +
                "FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE s.sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapSaleWithCustomer(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de vente par ID: " + e.getMessage(), e);
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

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                sales.add(mapSaleWithCustomer(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de toutes les ventes: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public void insertSaleItem(SaleItem saleItem) {
        String sql = "INSERT INTO sale_items (sale_id, product_id, inventory_id, " +
                "quantity, unit_price, discount, line_total) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors de l'insertion de l'item de vente: " + e.getMessage(), e);
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
            throw new RuntimeException("Erreur lors de la récupération des items de vente: " + e.getMessage(), e);
        }

        return items;
    }

    @Override
    public void deleteSaleItems(Integer saleId) {
        String sql = "DELETE FROM sale_items WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, saleId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression des items de vente: " + e.getMessage(), e);
        }
    }

    @Override
    public Boolean existsByIdAndStatus(Integer saleId, String status) {
        if (saleId == null || status == null) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM sales WHERE sale_id = ? AND payment_status = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, saleId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification de l'existence de la vente: " + e.getMessage(), e);
        }

        return false;
    }

    @Override
    public boolean updateStatus(Integer saleId, String status) {
        if (saleId == null || status == null) {
            return false;
        }

        String sql = "UPDATE sales SET payment_status = ?, updated_at = CURRENT_TIMESTAMP WHERE sale_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, saleId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du statut: " + e.getMessage(), e);
        }
    }

    @Override
    public Sale findSalesByIdAndStatus(Integer saleId, String status) {
        if (saleId == null || status == null) {
            return null;
        }

        String sql = "SELECT * FROM sales WHERE sale_id = ? AND payment_status = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, saleId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSale(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de vente par ID et statut: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public List<Sale> findSalesByCustomer(Integer customerId) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE s.customer_id = ? ORDER BY s.sale_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de ventes par client: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public List<Sale> findSalesByDate(LocalDate date) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE DATE(s.sale_date) = ? ORDER BY s.sale_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(date));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de ventes par date: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public Double getTotalRevenue(LocalDate start, LocalDate end) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM sales " +
                "WHERE DATE(sale_date) BETWEEN ? AND ?";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors du calcul du revenu total: " + e.getMessage(), e);
        }

        return 0.0;
    }

    @Override
    public Integer getTotalItemsSold(LocalDate start, LocalDate end) {
        String sql = "SELECT COALESCE(SUM(si.quantity), 0) " +
                "FROM sales s " +
                "JOIN sale_items si ON s.sale_id = si.sale_id " +
                "WHERE DATE(s.sale_date) BETWEEN ? AND ?";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors du calcul des items vendus: " + e.getMessage(), e);
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

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors de la récupération des produits les plus vendus: " + e.getMessage(), e);
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

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul des transactions d'aujourd'hui: " + e.getMessage(), e);
        }

        return 0;
    }

    @Override
    public List<Sale> getRecentSales(int limit) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "ORDER BY s.sale_date DESC LIMIT ?";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des ventes récentes: " + e.getMessage(), e);
        }

        return sales;
    }

    // ============================
    // MÉTHODES DE PAGINATION
    // ============================

    public List<Sale> getSalesWithPagination(int offset, int limit,
                                             String search, String customer, String paymentMethod,
                                             String status, String startDate, String endDate) {

        List<Sale> sales = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, c.first_name, c.last_name FROM sales s ")
                .append("LEFT JOIN customers c ON s.customer_id = c.customer_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (s.sale_id::text LIKE ? ");
            sql.append("OR LOWER(s.payment_method) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre client
        if (customer != null && !customer.trim().isEmpty()) {
            sql.append("AND (LOWER(c.first_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(c.last_name) LIKE LOWER(?)) ");

            String customerTerm = "%" + customer + "%";
            params.add(customerTerm);
            params.add(customerTerm);
        }

        // Filtre méthode de paiement
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append("AND s.payment_method = ? ");
            params.add(paymentMethod);
        }

        // Filtre statut
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND s.payment_status = ? ");
            params.add(status);
        }

        // Filtre date de début
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) >= ? ");
            params.add(Date.valueOf(startDate));
        }

        // Filtre date de fin
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND DATE(s.sale_date) <= ? ");
            params.add(Date.valueOf(endDate));
        }

        sql.append("ORDER BY s.sale_date DESC ");
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
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des ventes: " + e.getMessage(), e);
        }

        return sales;
    }

    public long getTotalSalesCount(String search, String customer, String paymentMethod,
                                   String status, String startDate, String endDate) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM sales s ")
                .append("LEFT JOIN customers c ON s.customer_id = c.customer_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (s.sale_id::text LIKE ? ");
            sql.append("OR LOWER(s.payment_method) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (customer != null && !customer.trim().isEmpty()) {
            sql.append("AND (LOWER(c.first_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(c.last_name) LIKE LOWER(?)) ");

            String customerTerm = "%" + customer + "%";
            params.add(customerTerm);
            params.add(customerTerm);
        }

        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append("AND s.payment_method = ? ");
            params.add(paymentMethod);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND s.payment_status = ? ");
            params.add(status);
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
            throw new RuntimeException("Erreur lors du comptage des ventes: " + e.getMessage(), e);
        }

        return 0;
    }

    // ============================
    // MÉTHODES SUPPLÉMENTAIRES
    // ============================

    @Override
    public List<Sale> findSalesByDateRange(LocalDate start, LocalDate end) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE DATE(s.sale_date) BETWEEN ? AND ? " +
                "ORDER BY s.sale_date DESC";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors de la recherche de ventes par plage de dates: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public List<Sale> findSalesByPaymentMethod(String paymentMethod) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE s.payment_method = ? ORDER BY s.sale_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, paymentMethod);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de ventes par méthode de paiement: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public List<Sale> findSalesByPrescription(Integer prescriptionId) {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.*, c.first_name, c.last_name FROM sales s " +
                "LEFT JOIN customers c ON s.customer_id = c.customer_id " +
                "WHERE s.prescription_id = ? ORDER BY s.sale_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, prescriptionId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sales.add(mapSaleWithCustomer(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de ventes par ordonnance: " + e.getMessage(), e);
        }

        return sales;
    }

    @Override
    public Integer getTotalTransactions(LocalDate start, LocalDate end) {
        String sql = "SELECT COUNT(*) FROM sales " +
                "WHERE DATE(sale_date) BETWEEN ? AND ?";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors du calcul du nombre total de transactions: " + e.getMessage(), e);
        }

        return 0;
    }

    @Override
    public List<Object[]> getDailySales(LocalDate start, LocalDate end) {
        List<Object[]> results = new ArrayList<>();
        String sql = "SELECT DATE(sale_date) as sale_day, " +
                "COUNT(*) as transactions, " +
                "SUM(total_amount) as revenue, " +
                "COALESCE(SUM(si.quantity), 0) as items_sold " +
                "FROM sales s " +
                "LEFT JOIN sale_items si ON s.sale_id = si.sale_id " +
                "WHERE DATE(s.sale_date) BETWEEN ? AND ? " +
                "GROUP BY DATE(sale_date) " +
                "ORDER BY sale_day";

        // ✅ CORRECT: try-with-resources
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
            throw new RuntimeException("Erreur lors de la récupération des ventes quotidiennes: " + e.getMessage(), e);
        }

        return results;
    }

    // ============================
    // MÉTHODES UTILITAIRES
    // ============================

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

        Timestamp saleTimestamp = rs.getTimestamp("sale_date");
        if (saleTimestamp != null) {
            sale.setSaleDate(saleTimestamp.toLocalDateTime());
        }

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

    private Sale mapResultSetToSale(ResultSet rs) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(rs.getInt("sale_id"));
        sale.setCustomerId(rs.getInt("customer_id"));
        sale.setSubtotal(rs.getDouble("subtotal"));
        sale.setDiscountAmount(rs.getDouble("discount_amount"));
        sale.setTaxAmount(rs.getDouble("tax_amount"));
        sale.setTotalAmount(rs.getDouble("total_amount"));
        sale.setPaymentMethod(rs.getString("payment_method"));
        sale.setPaymentStatus(rs.getString("payment_status"));
        sale.setNotes(rs.getString("notes"));
        sale.setServedBy(rs.getString("served_by"));

        Timestamp saleDate = rs.getTimestamp("sale_date");
        if (saleDate != null) {
            sale.setSaleDate(saleDate.toLocalDateTime());
        }

        return sale;
    }
}