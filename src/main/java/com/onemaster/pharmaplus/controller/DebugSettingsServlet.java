package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.ApplicationParameter;
import com.onemaster.pharmaplus.service.ApplicationParameterService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

@WebServlet("/debug-settings")
public class DebugSettingsServlet extends HttpServlet {
    
    private ApplicationParameterService parameterService;
    
    @Override
    public void init() {
        parameterService = new ApplicationParameterService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Debug Settings</title>");
        out.println("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">");
        out.println("</head><body>");
        out.println("<div class=\"container mt-4\">");
        out.println("<h1>Debug Settings Data</h1>");
        
        try {
            // Test 1: Récupérer les paramètres
            out.println("<h3>Test 1: Récupération des paramètres</h3>");
            List<ApplicationParameter> params = parameterService.getAllParameters();
            out.println("<p>Nombre de paramètres: " + params.size() + "</p>");
            
            // Test 2: Afficher les paramètres
            out.println("<h3>Test 2: Liste des paramètres</h3>");
            out.println("<table class=\"table table-striped\">");
            out.println("<thead><tr><th>#</th><th>Clé</th><th>Valeur</th><th>Type</th><th>Catégorie</th></tr></thead>");
            out.println("<tbody>");
            
            for (int i = 0; i < params.size(); i++) {
                ApplicationParameter p = params.get(i);
                out.println("<tr>");
                out.println("<td>" + (i + 1) + "</td>");
                out.println("<td>" + p.getParameterKey() + "</td>");
                out.println("<td>" + p.getParameterValue() + "</td>");
                out.println("<td>" + p.getParameterType() + "</td>");
                out.println("<td>" + p.getCategory() + "</td>");
                out.println("</tr>");
                
                // Limite à 10 pour la lisibilité
                if (i >= 9) {
                    out.println("<tr><td colspan=\"5\">... et " + (params.size() - 10) + " autres</td></tr>");
                    break;
                }
            }
            
            out.println("</tbody></table>");
            
            // Test 3: Vérifier la base de données
            out.println("<h3>Test 3: Connexion directe à la base</h3>");
            try {
                Class.forName("org.postgresql.Driver");
                String url = "jdbc:postgresql://localhost:5432/pharmaplus";
                String user = "postgres";
                String password = "123";
                
                try (Connection conn = DriverManager.getConnection(url, user, password);
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM application_parameters")) {
                    
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Count direct depuis DB: " + count + "</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p class=\"text-danger\">Erreur DB: " + e.getMessage() + "</p>");
            }
            
        } catch (Exception e) {
            out.println("<div class=\"alert alert-danger\">");
            out.println("<h4>Erreur:</h4>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</div>");
        }
        
        out.println("</div></body></html>");
    }
}