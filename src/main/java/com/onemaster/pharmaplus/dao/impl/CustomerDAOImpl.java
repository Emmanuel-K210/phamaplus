package com.onemaster.pharmaplus.dao.impl;

import com.onemaster.pharmaplus.config.DatabaseConnection;
import com.onemaster.pharmaplus.dao.service.CustomerDAO;
import com.onemaster.pharmaplus.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAOImpl implements CustomerDAO {

    @Override
    public List<Customer> getCustomersWithEmail() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE email IS NOT NULL AND email != '' ORDER BY last_name, first_name";

        // ✅ CORRECT: try-with-resources garantit la fermeture automatique
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapCustomerFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des clients avec email: " + e.getMessage(), e);
        }
        
        return customers;
    }

    @Override
    public List<Customer> getCustomersWithAllergies() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE allergies IS NOT NULL AND allergies != '' ORDER BY last_name, first_name";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapCustomerFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des clients avec allergies: " + e.getMessage(), e);
        }
        
        return customers;
    }

    @Override
    public void insert(Customer customer) {
        String sql = "INSERT INTO customers (first_name, last_name, phone, email, " +
                "date_of_birth, address, allergies) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getEmail());

            if (customer.getDateOfBirth() != null) {
                stmt.setDate(5, Date.valueOf(customer.getDateOfBirth()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.setString(6, customer.getAddress());
            stmt.setString(7, customer.getAllergies());

            stmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion du client: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Customer customer) {
        String sql = "UPDATE customers SET first_name = ?, last_name = ?, phone = ?, " +
                "email = ?, date_of_birth = ?, address = ?, allergies = ?, " +
                "updated_at = NOW() WHERE customer_id = ?";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getEmail());

            if (customer.getDateOfBirth() != null) {
                stmt.setDate(5, Date.valueOf(customer.getDateOfBirth()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.setString(6, customer.getAddress());
            stmt.setString(7, customer.getAllergies());
            stmt.setInt(8, customer.getCustomerId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Client non trouvé avec l'ID: " + customer.getCustomerId());
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du client: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer customerId) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new RuntimeException("Client non trouvé avec l'ID: " + customerId);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du client: " + e.getMessage(), e);
        }
    }

    @Override
    public Customer findById(Integer customerId) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCustomerFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur recherche client par ID: " + e.getMessage(), e);
        }
        
        return null;
    }

    @Override
    public List<Customer> findAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY last_name, first_name";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                customers.add(mapCustomerFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur liste clients: " + e.getMessage(), e);
        }
        
        return customers;
    }

    @Override
    public List<Customer> findByNameOrPhone(String searchTerm) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers " +
                "WHERE LOWER(first_name) LIKE LOWER(?) " +
                "OR LOWER(last_name) LIKE LOWER(?) " +
                "OR phone LIKE ? " +
                "ORDER BY last_name, first_name";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur recherche clients: " + e.getMessage(), e);
        }
        
        return customers;
    }

    @Override
    public Customer findByEmail(String email) {
        String sql = "SELECT * FROM customers WHERE LOWER(email) = LOWER(?)";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCustomerFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur recherche client par email: " + e.getMessage(), e);
        }
        
        return null;
    }

    @Override
    public Customer findByPhone(String phone) {
        String sql = "SELECT * FROM customers WHERE phone = ?";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phone);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapCustomerFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur recherche client par téléphone: " + e.getMessage(), e);
        }
        
        return null;
    }

    // Méthodes supplémentaires utiles

    public List<Customer> findCustomersWithPrescriptions() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* " +
                "FROM customers c " +
                "JOIN prescriptions p ON c.customer_id = p.customer_id " +
                "ORDER BY c.last_name, c.first_name";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                customers.add(mapCustomerFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur clients avec ordonnances: " + e.getMessage(), e);
        }
        
        return customers;
    }

    public int countAllCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur comptage clients: " + e.getMessage(), e);
        }
        
        return 0;
    }

    public List<Customer> findCustomersByBirthdayMonth(int month) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers " +
                "WHERE EXTRACT(MONTH FROM date_of_birth) = ? " +
                "ORDER BY EXTRACT(DAY FROM date_of_birth)";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, month);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur clients par mois d'anniversaire: " + e.getMessage(), e);
        }
        
        return customers;
    }

    public boolean customerExists(String email, String phone) {
        String sql = "SELECT COUNT(*) FROM customers WHERE email = ? OR phone = ?";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, phone);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur vérification existence client: " + e.getMessage(), e);
        }
        
        return false;
    }

    public Customer getLatestCustomer() {
        String sql = "SELECT * FROM customers ORDER BY customer_id DESC LIMIT 1";
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return mapCustomerFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur client récent: " + e.getMessage(), e);
        }
        
        return null;
    }

    public CustomerStats getCustomerStats() {
        CustomerStats stats = new CustomerStats();
        String sql = "SELECT " +
                "COUNT(*) as total, " +
                "COUNT(DISTINCT date_trunc('month', created_at)) as months, " +
                "AVG(CASE WHEN date_of_birth IS NOT NULL THEN " +
                "EXTRACT(YEAR FROM AGE(date_of_birth)) END) as avg_age " +
                "FROM customers";

        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                stats.setTotalCustomers(rs.getInt("total"));
                stats.setActiveMonths(rs.getInt("months"));
                stats.setAverageAge(rs.getDouble("avg_age"));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur statistiques clients: " + e.getMessage(), e);
        }

        return stats;
    }

    // Méthode utilitaire de mapping
    private Customer mapCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();

        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setFirstName(rs.getString("first_name"));
        customer.setLastName(rs.getString("last_name"));
        customer.setPhone(rs.getString("phone"));
        customer.setEmail(rs.getString("email"));

        Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            customer.setDateOfBirth(dob.toLocalDate());
        }

        customer.setAddress(rs.getString("address"));
        customer.setAllergies(rs.getString("allergies"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            customer.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            customer.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return customer;
    }

    // Classe interne pour les statistiques
    public static class CustomerStats {
        private int totalCustomers;
        private int activeMonths;
        private double averageAge;

        // Getters et Setters
        public int getTotalCustomers() {
            return totalCustomers;
        }

        public void setTotalCustomers(int totalCustomers) {
            this.totalCustomers = totalCustomers;
        }

        public int getActiveMonths() {
            return activeMonths;
        }

        public void setActiveMonths(int activeMonths) {
            this.activeMonths = activeMonths;
        }

        public double getAverageAge() {
            return averageAge;
        }

        public void setAverageAge(double averageAge) {
            this.averageAge = averageAge;
        }

        @Override
        public String toString() {
            return String.format("Clients: %d, Mois actifs: %d, Âge moyen: %.1f ans",
                    totalCustomers, activeMonths, averageAge);
        }
    }

    // ============================
    // NOUVELLES MÉTHODES POUR PAGINATION
    // ============================
    
    public List<Customer> getCustomersWithPagination(int offset, int limit, String search, 
            String sortBy, String sortOrder) {
        List<Customer> customers = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM customers ");
        
        List<Object> params = new ArrayList<>();
        
        // Filtre recherche
        if (search != null && !search.trim().isEmpty()) {
            sql.append("WHERE (LOWER(first_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(last_name) LIKE LOWER(?) ");
            sql.append("OR phone LIKE ? ");
            sql.append("OR LOWER(email) LIKE LOWER(?)) ");
            
            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        // Tri
        String orderBy = "last_name, first_name";
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy.toLowerCase()) {
                case "name":
                    orderBy = "last_name, first_name";
                    break;
                case "email":
                    orderBy = "email";
                    break;
                case "phone":
                    orderBy = "phone";
                    break;
                case "created":
                    orderBy = "created_at";
                    break;
            }
        }
        
        String orderDirection = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            orderDirection = "DESC";
        }
        
        sql.append("ORDER BY ").append(orderBy).append(" ").append(orderDirection).append(" ");
        sql.append("LIMIT ? OFFSET ?");
        
        params.add(limit);
        params.add(offset);
        
        // ✅ CORRECT: try-with-resources avec gestion des paramètres
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la pagination des clients: " + e.getMessage(), e);
        }
        
        return customers;
    }
    
    public long getTotalCustomersCount(String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM customers ");
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("WHERE (LOWER(first_name) LIKE LOWER(?) ");
            sql.append("OR LOWER(last_name) LIKE LOWER(?) ");
            sql.append("OR phone LIKE ? ");
            sql.append("OR LOWER(email) LIKE LOWER(?)) ");
            
            String searchTerm = "%" + search + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        // ✅ CORRECT
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, (String) params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des clients: " + e.getMessage(), e);
        }
        
        return 0;
    }
}