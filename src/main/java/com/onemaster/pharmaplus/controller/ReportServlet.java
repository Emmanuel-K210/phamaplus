package com.onemaster.pharmaplus.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.onemaster.pharmaplus.model.Report;
import com.onemaster.pharmaplus.service.ReportService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReportServlet", urlPatterns = {"/reports", "/reports/*"})
public class ReportServlet extends HttpServlet {
    
    private ReportService reportService;
    
    @Override
    public void init() {
        reportService = new ReportService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "";
        }
        
        try {
            switch (action) {
                case "/generate":
                    showGenerateForm(request, response);
                    break;
                case "/view":
                    viewReport(request, response);
                    break;
                case "/download":
                    downloadReport(request, response);
                    break;
                case "/delete":
                    deleteReport(request, response);
                    break;
                case "/sales":
                    generateSalesReport(request, response);
                    break;
                case "/stock":
                    generateStockReport(request, response);
                    break;
                case "/customers":
                    generateCustomerReport(request, response);
                    break;
                case "/financial":
                    generateFinancialReport(request, response);
                    break;
                case "/prescriptions":
                    generatePrescriptionReport(request, response);
                    break;
                default:
                    listReports(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/reports");
        }
    }

    private void generatePrescriptionReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            LocalDate startDate = parseDate(request.getParameter("startDate"));
            LocalDate endDate = parseDate(request.getParameter("endDate"));
            String format = request.getParameter("format");

            if (startDate == null) startDate = LocalDate.now().minusDays(30);
            if (endDate == null) endDate = LocalDate.now();
            if (format == null) format = "HTML";

            // Générer le rapport via le service
            Report report = reportService.generatePrescriptionReport(startDate, endDate, format);

            // Préparer les données pour la vue
            Map<String, Object> reportData = parseReportData(report);

            request.setAttribute("report", report);
            request.setAttribute("reportData", reportData);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("format", format);
            request.setAttribute("pageTitle", "Rapport des Ordonnances");
            request.setAttribute("contentPage", "/WEB-INF/views/reports/prescriptions.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/reports?error=Erreur+lors+de+la+génération+du+rapport+ordonnances: " +
                    URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void generateFinancialReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            LocalDate startDate = parseDate(request.getParameter("startDate"));
            LocalDate endDate = parseDate(request.getParameter("endDate"));
            String format = request.getParameter("format");

            if (startDate == null) startDate = LocalDate.now().minusDays(30);
            if (endDate == null) endDate = LocalDate.now();
            if (format == null) format = "HTML";

            // Générer le rapport via le service
            Report report = reportService.generateFinancialReport(startDate, endDate, format);

            // Préparer les données pour la vue
            Map<String, Object> reportData = parseReportData(report);

            request.setAttribute("report", report);
            request.setAttribute("reportData", reportData);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("format", format);
            request.setAttribute("pageTitle", "Rapport Financier");
            request.setAttribute("contentPage", "/WEB-INF/views/reports/financial.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/reports?error=Erreur+lors+de+la+génération+du+rapport+financier: " +
                    URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    // Méthode utilitaire pour parser les données du rapport
    private Map<String, Object> parseReportData(Report report) {
        Map<String, Object> data = new HashMap<>();

        if (report != null && report.getData() != null) {
            try {
                ObjectMapper mapper = new ObjectMapper();
                data = mapper.readValue(report.getData(), new TypeReference<Map<String, Object>>() {});
            } catch (Exception e) {
                // Si le parsing échoue, retourner une map vide
                data = new HashMap<>();
            }
        }

        return data;
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "";
        }
        
        try {
            switch (action) {
                case "/generate":
                    generateCustomReport(request, response);
                    break;
                case "/export":
                    exportReport(request, response);
                    break;
                default:
                    listReports(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/reports");
        }
    }

    private void exportReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            String format = request.getParameter("format");

            if (format == null) {
                format = "PDF";
            }

            Report report = reportService.getReportById(reportId);

            if (report == null) {
                response.sendRedirect(request.getContextPath() +
                        "/reports?error=Rapport+non+trouvé");
                return;
            }

            byte[] fileContent;
            String contentType;
            String fileExtension;

            switch (format.toUpperCase()) {
                case "PDF":
                    fileContent = generatePdfReport(report);
                    contentType = "application/pdf";
                    fileExtension = "pdf";
                    break;

                case "EXCEL":
                    fileContent = generateExcelReport(report);
                    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    fileExtension = "xlsx";
                    break;

                case "CSV":
                    fileContent = generateCsvReport(report);
                    contentType = "text/csv";
                    fileExtension = "csv";
                    break;

                case "HTML":
                default:
                    // Rediriger vers la vue HTML
                    response.sendRedirect(request.getContextPath() +
                            "/reports/view?id=" + reportId);
                    return;
            }

            // Configurer la réponse pour le téléchargement
            response.setContentType(contentType);
            response.setContentLength(fileContent.length);
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" +
                            generateFileName(report, fileExtension) + "\"");

            // Écrire le fichier dans la réponse
            try (ServletOutputStream out = response.getOutputStream()) {
                out.write(fileContent);
                out.flush();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reports?error=ID+invalide");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/reports?error=Erreur+lors+de+l'export: " +
                    URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    // Méthodes de génération des différents formats
    private byte[] generatePdfReport(Report report) throws Exception {
        // Implémentation avec iText ou autre bibliothèque PDF
        // Pour l'instant, retourner un tableau vide
        return new byte[0];
    }

    private byte[] generateExcelReport(Report report) throws Exception {
        // Implémentation avec Apache POI
        // Pour l'instant, retourner un tableau vide
        return new byte[0];
    }

    private byte[] generateCsvReport(Report report) throws Exception {
        StringBuilder csv = new StringBuilder();

        // En-tête
        csv.append("Rapport: ").append(report.getReportName()).append("\n");
        csv.append("Période: ").append(report.getStartDate())
                .append(" au ").append(report.getEndDate()).append("\n");
        csv.append("Généré le: ").append(report.getGeneratedAt()).append("\n\n");

        // Résumé
        csv.append("=== RÉSUMÉ ===\n");
        if (report.getSummary() != null) {
            for (Map.Entry<String, Object> entry : report.getSummary().entrySet()) {
                csv.append(entry.getKey()).append(": ").append(entry.getValue()).append("\n");
            }
        }

        // Détails
        csv.append("\n=== DÉTAILS ===\n");
        if (report.getDetails() != null && !report.getDetails().isEmpty()) {
            // En-tête des colonnes
            Map<String, Object> firstRow = report.getDetails().get(0);
            csv.append(String.join(",", firstRow.keySet())).append("\n");

            // Données
            for (Map<String, Object> row : report.getDetails()) {
                List<String> values = new ArrayList<>();
                for (Object value : row.values()) {
                    values.add(value != null ? value.toString() : "");
                }
                csv.append(String.join(",", values)).append("\n");
            }
        }

        return csv.toString().getBytes(StandardCharsets.UTF_8);
    }

    private String generateFileName(Report report, String extension) {
        String reportName = report.getReportName()
                .replaceAll("[^a-zA-Z0-9\\-\\s]", "")
                .replaceAll("\\s+", "_");

        String date = report.getGeneratedAt() != null ?
                report.getGeneratedAt().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) :
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));

        return reportName + "_" + date + "." + extension;
    }

    private void listReports(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String filter = request.getParameter("filter");
            List<Report> reports;
            
            if (filter != null && !filter.trim().isEmpty()) {
                reports = reportService.getReportsByType(filter);
            } else {
                reports = reportService.getAllReports();
            }
            
            request.setAttribute("reports", reports);
            request.setAttribute("pageActive","reports");
            request.setAttribute("reportTypes", getReportTypes());
            request.setAttribute("pageTitle", "Gestion des Rapports");
            request.setAttribute("contentPage", "/WEB-INF/views/reports/list.jsp");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des rapports", e);
        }
    }
    
    private void showGenerateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("reportTypes", getReportTypes());
        request.setAttribute("formats", getExportFormats());
        request.setAttribute("pageTitle", "Générer un Rapport");
        request.setAttribute("contentPage", "/WEB-INF/views/reports/generate.jsp");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
        dispatcher.forward(request, response);
    }
    
    private void viewReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            Report report = reportService.getReportById(reportId);
            
            if (report != null) {
                request.setAttribute("report", report);
                request.setAttribute("pageTitle", "Rapport: " + report.getReportName());
                request.setAttribute("contentPage", "/WEB-INF/views/reports/view.jsp");
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/reports?error=Rapport+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reports?error=ID+invalide");
        }
    }
    
    private void generateSalesReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LocalDate startDate = parseDate(request.getParameter("startDate"));
            LocalDate endDate = parseDate(request.getParameter("endDate"));
            String format = request.getParameter("format");
            
            if (startDate == null) startDate = LocalDate.now().minusDays(30);
            if (endDate == null) endDate = LocalDate.now();
            if (format == null) format = "HTML";
            
            Report report = reportService.generateSalesReport(startDate, endDate, format);
            
            response.sendRedirect(request.getContextPath() + 
                                "/reports/view?id=" + report.getReportId());
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/reports?error=Erreur+lors+de+la+génération: " + e.getMessage());
        }
    }
    
    private void generateStockReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String format = request.getParameter("format");
            if (format == null) format = "HTML";
            
            Report report = reportService.generateStockReport(format);
            
            response.sendRedirect(request.getContextPath() + 
                                "/reports/view?id=" + report.getReportId());
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/reports?error=Erreur+lors+de+la+génération: " + e.getMessage());
        }
    }
    
    private void generateCustomerReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            LocalDate startDate = parseDate(request.getParameter("startDate"));
            LocalDate endDate = parseDate(request.getParameter("endDate"));
            String format = request.getParameter("format");
            
            if (startDate == null) startDate = LocalDate.now().minusDays(90);
            if (endDate == null) endDate = LocalDate.now();
            if (format == null) format = "HTML";
            
            Report report = reportService.generateCustomerReport(startDate, endDate, format);
            
            response.sendRedirect(request.getContextPath() + 
                                "/reports/view?id=" + report.getReportId());
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/reports?error=Erreur+lors+de+la+génération: " + e.getMessage());
        }
    }
    
    private void generateCustomReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String reportType = request.getParameter("reportType");
            LocalDate startDate = parseDate(request.getParameter("startDate"));
            LocalDate endDate = parseDate(request.getParameter("endDate"));
            String format = request.getParameter("format");
            
            Map<String, Object> parameters = new HashMap<>();
            request.getParameterMap().forEach((key, value) -> {
                if (!key.equals("reportType") && !key.equals("startDate") && 
                    !key.equals("endDate") && !key.equals("format")) {
                    parameters.put(key, value[0]);
                }
            });
            
            Report report;
            switch (reportType) {
                case "SALES":
                    report = reportService.generateSalesReport(startDate, endDate, format);
                    break;
                case "STOCK":
                    report = reportService.generateStockReport(format);
                    break;
                case "CUSTOMER":
                    report = reportService.generateCustomerReport(startDate, endDate, format);
                    break;
                case "FINANCIAL":
                    report = reportService.generateFinancialReport(startDate, endDate, format);
                    break;
                case "PRESCRIPTION":
                    report = reportService.generatePrescriptionReport(startDate, endDate, format);
                    break;
                default:
                    throw new IllegalArgumentException("Type de rapport non supporté: " + reportType);
            }
            
            response.sendRedirect(request.getContextPath() + 
                                "/reports/view?id=" + report.getReportId());
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/reports?error=Erreur+lors+de+la+génération: " + e.getMessage());
        }
    }
    
    private void downloadReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            Report report = reportService.getReportById(reportId);
            
            if (report != null && report.getFilePath() != null) {
                // Logique de téléchargement du fichier
                // À implémenter selon le format
            } else {
                response.sendRedirect(request.getContextPath() + 
                                    "/reports?error=Fichier+non+disponible");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reports?error=ID+invalide");
        }
    }
    
    private void deleteReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            reportService.deleteReport(reportId);
            
            response.sendRedirect(request.getContextPath() + 
                                "/reports?success=Rapport+supprimé+avec+succès");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reports?error=ID+invalide");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/reports?error=Erreur+lors+de+la+suppression: " + e.getMessage());
        }
    }
    
    // Méthodes utilitaires
    private LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (Exception e) {
            return null;
        }
    }
    
    private Map<String, String> getReportTypes() {
        Map<String, String> types = new HashMap<>();
        types.put("SALES", "Rapport de Ventes");
        types.put("STOCK", "Rapport de Stock");
        types.put("CUSTOMER", "Rapport Clients");
        types.put("FINANCIAL", "Rapport Financier");
        types.put("PRESCRIPTION", "Rapport Ordonnances");
        types.put("INVENTORY", "Rapport Inventaire");
        types.put("PRODUCT", "Rapport Produits");
        return types;
    }
    
    private Map<String, String> getExportFormats() {
        Map<String, String> formats = new HashMap<>();
        formats.put("HTML", "HTML (Web)");
        formats.put("PDF", "PDF (Document)");
        formats.put("EXCEL", "Excel (Feuille de calcul)");
        formats.put("CSV", "CSV (Données)");
        return formats;
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           Exception e, String redirectPath) 
            throws ServletException, IOException {
        
        e.printStackTrace();
        
        if (response.isCommitted()) {
            return;
        }
        
        String errorMessage = "Erreur : " + e.getMessage();
        response.sendRedirect(request.getContextPath() + redirectPath + "?error=" + 
                            java.net.URLEncoder.encode(errorMessage, "UTF-8"));
    }
}