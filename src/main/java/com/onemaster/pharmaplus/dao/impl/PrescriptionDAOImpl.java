package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.PrescriptionDAO;
import com.onemaster.pharmaplus.model.Medication;
import com.onemaster.pharmaplus.model.Prescription;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAOImpl implements PrescriptionDAO {
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    public void insert(Prescription prescription) {
        String sql = "INSERT INTO prescriptions (customer_id, customer_name, doctor_name, " +
                     "doctor_license, prescription_date, validity_date, diagnosis, notes, " +
                     "is_filled, filled_date, medications) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, prescription.getCustomerId());
            stmt.setString(2, prescription.getCustomerName());
            stmt.setString(3, prescription.getDoctorName());
            stmt.setString(4, prescription.getDoctorLicense());
            stmt.setDate(5, Date.valueOf(prescription.getPrescriptionDate()));
            stmt.setDate(6, Date.valueOf(prescription.getValidityDate()));
            stmt.setString(7, prescription.getDiagnosis());
            stmt.setString(8, prescription.getNotes());
            stmt.setBoolean(9, prescription.isFilled());
            
            if (prescription.getFilledDate() != null) {
                stmt.setDate(10, Date.valueOf(prescription.getFilledDate()));
            } else {
                stmt.setNull(10, Types.DATE);
            }
            
            stmt.setString(11, objectMapper.writeValueAsString(prescription.getMedications()));
            
            stmt.executeUpdate();
            
            // Récupérer l'ID généré
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    prescription.setPrescriptionId(generatedKeys.getInt(1));
                }
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de l'insertion de l'ordonnance", e);
        }
    }
    
    @Override
    public void update(Prescription prescription) {
        String sql = "UPDATE prescriptions SET customer_id = ?, customer_name = ?, doctor_name = ?, " +
                     "doctor_license = ?, prescription_date = ?, validity_date = ?, diagnosis = ?, " +
                     "notes = ?, is_filled = ?, filled_date = ?, medications = ?, updated_at = NOW() " +
                     "WHERE prescription_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescription.getCustomerId());
            stmt.setString(2, prescription.getCustomerName());
            stmt.setString(3, prescription.getDoctorName());
            stmt.setString(4, prescription.getDoctorLicense());
            stmt.setDate(5, Date.valueOf(prescription.getPrescriptionDate()));
            stmt.setDate(6, Date.valueOf(prescription.getValidityDate()));
            stmt.setString(7, prescription.getDiagnosis());
            stmt.setString(8, prescription.getNotes());
            stmt.setBoolean(9, prescription.isFilled());
            
            if (prescription.getFilledDate() != null) {
                stmt.setDate(10, Date.valueOf(prescription.getFilledDate()));
            } else {
                stmt.setNull(10, Types.DATE);
            }
            
            stmt.setString(11, objectMapper.writeValueAsString(prescription.getMedications()));
            stmt.setInt(12, prescription.getPrescriptionId());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Ordonnance non trouvée avec l'ID: " + prescription.getPrescriptionId());
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la mise à jour de l'ordonnance", e);
        }
    }
    
    @Override
    public void delete(Integer prescriptionId) {
        String sql = "DELETE FROM prescriptions WHERE prescription_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescriptionId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Ordonnance non trouvée avec l'ID: " + prescriptionId);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression de l'ordonnance", e);
        }
    }
    
    @Override
    public Prescription findById(Integer prescriptionId) {
        String sql = "SELECT * FROM prescriptions WHERE prescription_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescriptionId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapFromResultSet(rs);
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la recherche de l'ordonnance", e);
        }
        return null;
    }
    
    @Override
    public List<Prescription> findAll() {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions ORDER BY prescription_date DESC, prescription_id DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances", e);
        }
        return prescriptions;
    }
    
    @Override
    public List<Prescription> findByCustomerId(Integer customerId) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE customer_id = ? ORDER BY prescription_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances par client", e);
        }
        return prescriptions;
    }
    
    @Override
    public List<Prescription> findByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE prescription_date BETWEEN ? AND ? " +
                     "ORDER BY prescription_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances par date", e);
        }
        return prescriptions;
    }
    
    @Override
    public List<Prescription> findByDoctor(String doctorName) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE LOWER(doctor_name) LIKE LOWER(?) " +
                     "ORDER BY prescription_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + doctorName + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances par médecin", e);
        }
        return prescriptions;
    }
    
    @Override
    public List<Prescription> findPendingPrescriptions() {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE is_filled = false AND validity_date >= CURDATE() " +
                     "ORDER BY prescription_date";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances en attente", e);
        }
        return prescriptions;
    }
    
    @Override
    public List<Prescription> findExpiredPrescriptions() {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE validity_date < CURDATE() AND is_filled = false " +
                     "ORDER BY validity_date";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances expirées", e);
        }
        return prescriptions;
    }
    
    @Override
    public int countByStatus(boolean filled) {
        String sql = "SELECT COUNT(*) FROM prescriptions WHERE is_filled = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, filled);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des ordonnances", e);
        }
        return 0;
    }
    
    @Override
    public List<Prescription> search(String searchTerm) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE " +
                     "customer_name LIKE ? OR doctor_name LIKE ? OR diagnosis LIKE ? " +
                     "ORDER BY prescription_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String pattern = "%" + searchTerm + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la recherche d'ordonnances", e);
        }
        return prescriptions;
    }
    
    // Méthode de mapping
    private Prescription mapFromResultSet(ResultSet rs) throws Exception {
        Prescription prescription = new Prescription();
        
        prescription.setPrescriptionId(rs.getInt("prescription_id"));
        prescription.setCustomerId(rs.getInt("customer_id"));
        prescription.setCustomerName(rs.getString("customer_name"));
        prescription.setDoctorName(rs.getString("doctor_name"));
        prescription.setDoctorLicense(rs.getString("doctor_license"));
        
        Date prescriptionDate = rs.getDate("prescription_date");
        if (prescriptionDate != null) {
            prescription.setPrescriptionDate(prescriptionDate.toLocalDate());
        }
        
        Date validityDate = rs.getDate("validity_date");
        if (validityDate != null) {
            prescription.setValidityDate(validityDate.toLocalDate());
        }
        
        prescription.setDiagnosis(rs.getString("diagnosis"));
        prescription.setNotes(rs.getString("notes"));
        prescription.setFilled(rs.getBoolean("is_filled"));
        
        Date filledDate = rs.getDate("filled_date");
        if (filledDate != null) {
            prescription.setFilledDate(filledDate.toLocalDate());
        }
        
        // Désérialiser les médicaments depuis JSON
        String medicationsJson = rs.getString("medications");
        if (medicationsJson != null && !medicationsJson.trim().isEmpty()) {
            List<Medication> medications = objectMapper.readValue(
                medicationsJson, 
                new TypeReference<List<Medication>>() {}
            );
            prescription.setMedications(medications);
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            prescription.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            prescription.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return prescription;
    }
    
    // Méthodes supplémentaires utiles
    public List<Prescription> findTodayPrescriptions() {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE DATE(prescription_date) = CURDATE() " +
                     "ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances du jour", e);
        }
        return prescriptions;
    }
    
    public int countAllPrescriptions() {
        String sql = "SELECT COUNT(*) FROM prescriptions";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du comptage des ordonnances", e);
        }
        return 0;
    }
    
    public List<Prescription> findPrescriptionsToExpire(int daysBefore) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE is_filled = false AND " +
                     "validity_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL ? DAY) " +
                     "ORDER BY validity_date";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, daysBefore);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapFromResultSet(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du chargement des ordonnances à expirer", e);
        }
        return prescriptions;
    }
}