package com.onemaster.pharmaplus.model;

public class Medication {
    private String name;
    private String dosage;
    private String frequency;
    private int duration; // en jours
    private int quantity;
    private String instructions;
    private double price;

    // Getters et Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}