package com.onemaster.pharmaplus.dao.impl;


import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.MedicalReceiptDAO;
import com.onemaster.pharmaplus.model.MedicalReceipt;
import com.onemaster.pharmaplus.utils.JdbcUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MedicalReceiptDAOImpl implements MedicalReceiptDAO {

    @Override
    public Integer save(MedicalReceipt receipt) {
        // PostgreSQL utilise RETURNING pour récupérer l'ID
        String sql = "INSERT INTO medical_receipts (receipt_number, receipt_date, patient_name, " +
                "patient_contact, service_type, amount, amount_in_words, served_by, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                "RETURNING receipt_id";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, receipt.getReceiptNumber());
            stmt.setTimestamp(2, Timestamp.valueOf(receipt.getReceiptDate()));
            stmt.setString(3, receipt.getPatientName());
            stmt.setString(4, receipt.getPatientContact());
            stmt.setString(5, receipt.getServiceType());
            stmt.setDouble(6, receipt.getAmount());
            stmt.setString(7, receipt.getAmountInWords());
            stmt.setString(8, receipt.getServedBy());
            stmt.setString(9, receipt.getNotes());

            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("receipt_id");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return null;
    }

    @Override
    public MedicalReceipt findById(Integer id) {
        String sql = "SELECT * FROM medical_receipts WHERE receipt_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToReceipt(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs, pstmt);
        }
        return null;
    }

    @Override
    public List<MedicalReceipt> findAll() {
        List<MedicalReceipt> receipts = new ArrayList<>();
        // PostgreSQL: LIMIT sans OFFSET pour toutes les lignes
        String sql = "SELECT * FROM medical_receipts ORDER BY receipt_date DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                receipts.add(mapResultSetToReceipt(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs, pstmt);
        }
        return receipts;
    }

    @Override
    public List<MedicalReceipt> findByDateRange(LocalDateTime start, LocalDateTime end) {
        List<MedicalReceipt> receipts = new ArrayList<>();
        // PostgreSQL: CAST pour le timestamp
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM medical_receipts " +
                "WHERE receipt_date BETWEEN ? AND ? " +
                "ORDER BY receipt_date DESC";

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setTimestamp(1, Timestamp.valueOf(start));
            pstmt.setTimestamp(2, Timestamp.valueOf(end));

            rs = pstmt.executeQuery();
            while (rs.next()) {
                receipts.add(mapResultSetToReceipt(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return receipts;
    }

    @Override
    public boolean update(MedicalReceipt receipt) {
        String sql = "UPDATE medical_receipts SET " +
                "patient_name = ?, patient_contact = ?, " +
                "service_type = ?, amount = ?, amount_in_words = ?, notes = ? " +
                "WHERE receipt_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, receipt.getPatientName());
            pstmt.setString(2, receipt.getPatientContact());
            pstmt.setString(3, receipt.getServiceType());
            pstmt.setDouble(4, receipt.getAmount());
            pstmt.setString(5, receipt.getAmountInWords());
            pstmt.setString(6, receipt.getNotes());
            pstmt.setInt(7, receipt.getReceiptId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(pstmt);
        }
        return false;
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM medical_receipts WHERE receipt_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(pstmt);
        }
        return false;
    }

    @Override
    public String generateReceiptNumber() {
        // PostgreSQL: Appel de fonction avec SELECT
        String sql = "SELECT generate_receipt_number()";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Fallback si la fonction n'existe pas
            return generateFallbackReceiptNumber();
        } finally {
            JdbcUtil.close(rs, stmt);
        }
        return null;
    }

    private String generateFallbackReceiptNumber() {
        // Fallback pour PostgreSQL
        String sql = "SELECT 'REC-' || " +
                "TO_CHAR(CURRENT_DATE, 'YYYYMM') || '-' || " +
                "LPAD(COALESCE(MAX(SUBSTRING(receipt_number FROM '-(\\d+)$')::INTEGER), 0) + 1, 6, '0') " +
                "FROM medical_receipts " +
                "WHERE receipt_number LIKE 'REC-' || TO_CHAR(CURRENT_DATE, 'YYYYMM') || '-%'";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                String generated = rs.getString(1);
                return generated != null ? generated :
                        "REC-" + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM")) + "-000001";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs, stmt);
        }

        // Fallback final
        return "REC-" + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM")) + "-000001";
    }

    private MedicalReceipt mapResultSetToReceipt(ResultSet rs) throws SQLException {
        MedicalReceipt receipt = new MedicalReceipt();

        receipt.setReceiptId(rs.getInt("receipt_id"));
        receipt.setReceiptNumber(rs.getString("receipt_number"));

        // PostgreSQL: getTimestamp fonctionne de la même manière
        Timestamp timestamp = rs.getTimestamp("receipt_date");
        if (timestamp != null) {
            receipt.setReceiptDate(timestamp.toLocalDateTime());
        }

        receipt.setPatientName(rs.getString("patient_name"));
        receipt.setPatientContact(rs.getString("patient_contact"));
        receipt.setServiceType(rs.getString("service_type"));
        receipt.setAmount(rs.getDouble("amount")); // PostgreSQL: getDouble fonctionne avec NUMERIC
        receipt.setAmountInWords(rs.getString("amount_in_words"));
        receipt.setServedBy(rs.getString("served_by"));
        receipt.setNotes(rs.getString("notes"));

        return receipt;
    }

    // Méthodes supplémentaires pour PostgreSQL
    public List<String> getServiceTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT service_type FROM medical_receipts ORDER BY service_type";

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                types.add(rs.getString("service_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JdbcUtil.close(rs,stmt);
        }
        return types;
    }

    public Double getTotalRevenueByDate(LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM medical_receipts " +
                "WHERE receipt_date BETWEEN ? AND ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try { conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setTimestamp(1, Timestamp.valueOf(start));
            pstmt.setTimestamp(2, Timestamp.valueOf(end));

             rs = pstmt.executeQuery();
                if (rs.next()) {
                    return rs.getDouble("total");
                }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JdbcUtil.close(rs, stmt);
        }
        return 0.0;
    }
}