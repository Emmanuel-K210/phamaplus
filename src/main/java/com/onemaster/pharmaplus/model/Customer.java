package com.onemaster.pharmaplus.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.ZoneId;
import java.util.Date;

public class Customer {
    private Integer customerId;
    private String firstName;
    private String lastName;
    private String phone;
    private String email;
    private LocalDate dateOfBirth;
    private String address;
    private String allergies;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private transient int age;
    
    // Constructeurs
    public Customer() {}
    
    public Customer(String firstName, String lastName, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
    }
    
    // Getters/Setters
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
        // Calculer automatiquement l'âge lors de la définition de la date de naissance
        if (dateOfBirth != null) {
            this.age = Period.between(dateOfBirth, LocalDate.now()).getYears();
        }
    }

    public Date getDateOfBirthAsDate() {
        if (dateOfBirth != null) {
            LocalDateTime dateTime = dateOfBirth.atStartOfDay();
            Date.from(dateTime.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }


    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    /**
     * Récupère l'âge calculé du client
     * @return âge en années, ou 0 si la date de naissance n'est pas définie
     */
    public int getAge() {
        if (dateOfBirth != null) {
            return Period.between(dateOfBirth, LocalDate.now()).getYears();
        }
        return 0;
    }

    /**
     * Définit l'âge (utile pour les objets désérialisés)
     * @param age l'âge à définir
     */
    public void setAge(int age) {
        this.age = age;
    }

    /**
     * Retourne le nom complet du client
     * @return prénom + nom
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }

    /**
     * Vérifie si le client a une allergie
     * @return true si des allergies sont enregistrées
     */
    public boolean hasAllergies() {
        return allergies != null && !allergies.trim().isEmpty();
    }

    /**
     * Vérifie si le client a un email
     * @return true si un email est enregistré
     */
    public boolean hasEmail() {
        return email != null && !email.trim().isEmpty();
    }

    /**
     * Vérifie si le client est majeur
     * @return true si l'âge >= 18 ans
     */
    public boolean isAdult() {
        return getAge() >= 18;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "customerId=" + customerId +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", age=" + getAge() +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Customer customer = (Customer) o;
        return customerId == customer.customerId;
    }

    public Date getCreatedAtAsDate() {
        if (createdAt != null) {
            return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(customerId);
    }
}