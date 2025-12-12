package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.MedicalReceiptDAO;
import com.onemaster.pharmaplus.model.MedicalReceipt;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class MedicalReceiptDAOImpl implements MedicalReceiptDAO {

    @Override
    public Integer save(MedicalReceipt receipt) {
        String sql = "INSERT INTO medical_receipts (receipt_number, receipt_date, patient_name, " +
                "patient_contact, service_type, amount, amount_in_words, served_by, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                "RETURNING receipt_id";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, receipt.getReceiptNumber());
            stmt.setTimestamp(2, Timestamp.valueOf(receipt.getReceiptDate()));
            stmt.setString(3, receipt.getPatientName());
            stmt.setString(4, receipt.getPatientContact());
            stmt.setString(5, receipt.getServiceType());
            stmt.setDouble(6, receipt.getAmount());
            stmt.setString(7, receipt.getAmountInWords());
            stmt.setString(8, receipt.getServedBy());
            stmt.setString(9, receipt.getNotes());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("receipt_id");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la sauvegarde du reçu médical: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public MedicalReceipt findById(Integer id) {
        String sql = "SELECT * FROM medical_receipts WHERE receipt_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReceipt(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du reçu par ID: " + e.getMessage(), e);
        }

        return null;
    }

    @Override
    public List<MedicalReceipt> findAll() {
        List<MedicalReceipt> receipts = new ArrayList<>();
        String sql = "SELECT * FROM medical_receipts ORDER BY receipt_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                receipts.add(mapResultSetToReceipt(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de tous les reçus: " + e.getMessage(), e);
        }

        return receipts;
    }

    @Override
    public List<MedicalReceipt> findByDateRange(LocalDateTime start, LocalDateTime end) {
        List<MedicalReceipt> receipts = new ArrayList<>();
        String sql = "SELECT * FROM medical_receipts " +
                "WHERE receipt_date BETWEEN ? AND ? " +
                "ORDER BY receipt_date DESC";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    receipts.add(mapResultSetToReceipt(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche par plage de dates: " + e.getMessage(), e);
        }

        return receipts;
    }

    @Override
    public boolean update(MedicalReceipt receipt) {
        String sql = "UPDATE medical_receipts SET " +
                "patient_name = ?, patient_contact = ?, " +
                "service_type = ?, amount = ?, amount_in_words = ?, notes = ? " +
                "WHERE receipt_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, receipt.getPatientName());
            stmt.setString(2, receipt.getPatientContact());
            stmt.setString(3, receipt.getServiceType());
            stmt.setDouble(4, receipt.getAmount());
            stmt.setString(5, receipt.getAmountInWords());
            stmt.setString(6, receipt.getNotes());
            stmt.setInt(7, receipt.getReceiptId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du reçu: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM medical_receipts WHERE receipt_id = ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du reçu: " + e.getMessage(), e);
        }
    }

    @Override
    public String generateReceiptNumber() {
        // Essayer d'abord la fonction PostgreSQL
        String sql = "SELECT generate_receipt_number()";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getString(1);
            }

        } catch (SQLException e) {
            // Fallback si la fonction n'existe pas
            System.out.println("Fonction generate_receipt_number() non trouvée, utilisation du fallback");
            return generateFallbackReceiptNumber();
        }

        return null;
    }

    private String generateFallbackReceiptNumber() {
        String sql = "SELECT 'REC-' || " +
                "TO_CHAR(CURRENT_DATE, 'YYYYMM') || '-' || " +
                "LPAD(COALESCE(MAX(SUBSTRING(receipt_number FROM '-(\\d+)$')::INTEGER), 0) + 1, 6, '0') " +
                "FROM medical_receipts " +
                "WHERE receipt_number LIKE 'REC-' || TO_CHAR(CURRENT_DATE, 'YYYYMM') || '-%'";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                String generated = rs.getString(1);
                return generated != null ? generated :
                        "REC-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMM")) + "-000001";
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la génération du numéro de reçu: " + e.getMessage(), e);
        }

        // Fallback final
        return "REC-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMM")) + "-000001";
    }

    private MedicalReceipt mapResultSetToReceipt(ResultSet rs) throws SQLException {
        MedicalReceipt receipt = new MedicalReceipt();

        receipt.setReceiptId(rs.getInt("receipt_id"));
        receipt.setReceiptNumber(rs.getString("receipt_number"));

        Timestamp timestamp = rs.getTimestamp("receipt_date");
        if (timestamp != null) {
            receipt.setReceiptDate(timestamp.toLocalDateTime());
        }

        receipt.setPatientName(rs.getString("patient_name"));
        receipt.setPatientContact(rs.getString("patient_contact"));
        receipt.setServiceType(rs.getString("service_type"));
        receipt.setAmount(rs.getDouble("amount"));
        receipt.setAmountInWords(rs.getString("amount_in_words"));
        receipt.setServedBy(rs.getString("served_by"));
        receipt.setNotes(rs.getString("notes"));

        return receipt;
    }

    // ============================
    // MÉTHODES SUPPLÉMENTAIRES
    // ============================

    public List<String> getServiceTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT service_type FROM medical_receipts ORDER BY service_type";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                types.add(rs.getString("service_type"));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des types de service: " + e.getMessage(), e);
        }

        return types;
    }

    public Double getTotalRevenueByDate(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM medical_receipts " +
                "WHERE receipt_date BETWEEN ? AND ?";

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, Timestamp.valueOf(start));
            stmt.setTimestamp(2, Timestamp.valueOf(end));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul du revenu total: " + e.getMessage(), e);
        }

        return 0.0;
    }

    // ============================
    // MÉTHODES DE PAGINATION
    // ============================

    public List<MedicalReceipt> getReceiptsWithPagination(int offset, int limit,
                                                          String search, String serviceType, String startDate, String endDate) {
        List<MedicalReceipt> receipts = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM medical_receipts WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(patient_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(receipt_number) LIKE LOWER(?) ");
            sql.append("OR LOWER(patient_contact) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Filtre type de service
        if (serviceType != null && !serviceType.trim().isEmpty()) {
            sql.append("AND service_type = ? ");
            params.add(serviceType);
        }

        // Filtre date de début
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND receipt_date >= ? ");
            params.add(Timestamp.valueOf(startDate + " 00:00:00"));
        }

        // Filtre date de fin
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND receipt_date <= ? ");
            params.add(Timestamp.valueOf(endDate + " 23:59:59"));
        }

        sql.append("ORDER BY receipt_date DESC ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(limit);
        params.add(offset);

        // ✅ CORRECT: try-with-resources avec gestion des paramètres
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Timestamp) {
                    stmt.setTimestamp(i + 1, (Timestamp) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    receipts.add(mapResultSetToReceipt(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des reçus: " + e.getMessage(), e);
        }

        return receipts;
    }

    public long getTotalReceiptsCount(String search, String serviceType,
                                      String startDate, String endDate) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM medical_receipts WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Appliquer les mêmes filtres
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(patient_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(receipt_number) LIKE LOWER(?) ");
            sql.append("OR LOWER(patient_contact) LIKE LOWER(?)) ");

            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (serviceType != null && !serviceType.trim().isEmpty()) {
            sql.append("AND service_type = ? ");
            params.add(serviceType);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND receipt_date >= ? ");
            params.add(Timestamp.valueOf(startDate + " 00:00:00"));
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND receipt_date <= ? ");
            params.add(Timestamp.valueOf(endDate + " 23:59:59"));
        }

        // ✅ CORRECT: try-with-resources
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Timestamp) {
                    stmt.setTimestamp(i + 1, (Timestamp) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des reçus: " + e.getMessage(), e);
        }

        return 0;
    }
}