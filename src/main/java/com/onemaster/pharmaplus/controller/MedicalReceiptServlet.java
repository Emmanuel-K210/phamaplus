package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.MedicalReceipt;
import com.onemaster.pharmaplus.model.MedicalReceiptDTO;
import com.onemaster.pharmaplus.service.MedicalReceiptService;
import com.onemaster.pharmaplus.utils.AmountToWordsConverter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/medical-receipts/*")
public class MedicalReceiptServlet extends HttpServlet {

    private MedicalReceiptService receiptService;
    private Gson gson;

    @Override
    public void init() {
        receiptService = new MedicalReceiptService();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        String pathInfo = request.getPathInfo();

        // API endpoints pour AJAX
        if (pathInfo != null && pathInfo.startsWith("/api/")) {
            handleApiGet(request, response, pathInfo);
            return;
        }

        // Routes principales
        if (pathInfo == null || pathInfo.equals("/")) {
            showReceiptList(request, response);
        } else if (pathInfo.equals("/new")) {
            showNewReceiptForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditReceiptForm(request, response);
        } else if (pathInfo.matches("/\\d+")) {
            showReceiptDetails(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/api/")) {
            handleApiPost(request, response, pathInfo);
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createReceipt(request, response);
        } else if ("update".equals(action)) {
            updateReceipt(request, response);
        } else if ("delete".equals(action)) {
            deleteReceipt(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ========== MÉTHODES DE VUE ==========

    // Modification de la méthode showReceiptList pour calculer les statistiques
    private void showReceiptList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        List<MedicalReceipt> receipts;

        if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
            LocalDateTime start = LocalDateTime.parse(startDateStr + "T00:00:00");
            LocalDateTime end = LocalDateTime.parse(endDateStr + "T23:59:59");
            receipts = receiptService.getReceiptsByDateRange(start, end);
        } else {
            receipts = receiptService.getAllReceipts();
        }

        List<MedicalReceiptDTO> receiptDTOs = receipts.stream()
                .map(MedicalReceiptDTO::new)
                .collect(Collectors.toList());

        request.setAttribute("receipts", receiptDTOs);
        request.setAttribute("totalReceipts", receipts.size());

        double totalRevenue = receipts.stream()
                .mapToDouble(MedicalReceipt::getAmount)
                .sum();
        request.setAttribute("totalRevenue", totalRevenue);

        // Calculer les statistiques pour aujourd'hui
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime todayEnd = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);
        long todayCount = receiptService.getReceiptsByDateRange(todayStart, todayEnd).size();
        request.setAttribute("todayCount", todayCount);

        // Calculer les statistiques pour les 7 derniers jours
        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        long weeklyCount = receiptService.getReceiptsByDateRange(weekAgo, LocalDateTime.now()).size();
        request.setAttribute("weeklyCount", weeklyCount);

        // Layout configuration
        request.setAttribute("pageTitle", "Reçus Médicaux");
        request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showNewReceiptForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String receiptNumber = receiptService.generateReceiptNumber();
        request.setAttribute("receiptNumber", receiptNumber);
        request.setAttribute("currentDate", LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")));
        
        // Layout configuration
        request.setAttribute("pageTitle", "Nouveau Reçu Médical");
        request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showEditReceiptForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID requis");
            return;
        }

        Integer id = Integer.parseInt(idParam);
        MedicalReceipt receipt = receiptService.getReceiptById(id);

        if (receipt == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reçu non trouvé");
            return;
        }

        request.setAttribute("receipt", new MedicalReceiptDTO(receipt));
        request.setAttribute("isEdit", true);
        
        // Layout configuration
        request.setAttribute("pageTitle", "Modifier Reçu Médical");
        request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showReceiptDetails(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        
        Integer id = Integer.parseInt(pathInfo.substring(1));
        MedicalReceipt receipt = receiptService.getReceiptById(id);

        if (receipt == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("receipt", new MedicalReceiptDTO(receipt));
        
        // Layout configuration
        request.setAttribute("pageTitle", "Détails Reçu Médical");
        request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/details.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    // ========== MÉTHODES CRUD ==========

    private void createReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            MedicalReceipt receipt = buildReceiptFromRequest(request);
            
            // Convertir montant en lettres
            double amount = receipt.getAmount();
            String amountInWords = AmountToWordsConverter.convert(amount);
            receipt.setAmountInWords(amountInWords);
            
            Integer receiptId = receiptService.saveReceipt(receipt);
            
            if (receiptId != null) {
                request.getSession().setAttribute("successMessage", 
                    "Reçu créé avec succès : " + receipt.getReceiptNumber());
                response.sendRedirect(request.getContextPath() + "/medical-receipts/" + receiptId);
            } else {
                request.setAttribute("errorMessage", "Erreur lors de la création du reçu");
                request.setAttribute("receipt", receipt);
                request.setAttribute("pageTitle", "Nouveau Reçu Médical");
                request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            request.setAttribute("pageTitle", "Nouveau Reçu Médical");
            request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    private void updateReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Integer id = Integer.parseInt(request.getParameter("receiptId"));
            MedicalReceipt existingReceipt = receiptService.getReceiptById(id);
            
            if (existingReceipt == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Mise à jour des champs modifiables
            existingReceipt.setPatientName(request.getParameter("patientName"));
            existingReceipt.setPatientContact(request.getParameter("patientContact"));
            existingReceipt.setServiceType(request.getParameter("serviceType"));
            
            double amount = Double.parseDouble(request.getParameter("amount"));
            existingReceipt.setAmount(amount);
            existingReceipt.setAmountInWords(AmountToWordsConverter.convert(amount));
            
            existingReceipt.setNotes(request.getParameter("notes"));
            existingReceipt.setServedBy(request.getParameter("servedBy"));
            existingReceipt.setUpdatedAt(LocalDateTime.now());

            boolean success = receiptService.updateReceipt(existingReceipt);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Reçu modifié avec succès");
                response.sendRedirect(request.getContextPath() + "/medical-receipts/" + id);
            } else {
                request.setAttribute("errorMessage", "Erreur lors de la modification");
                request.setAttribute("receipt", new MedicalReceiptDTO(existingReceipt));
                request.setAttribute("isEdit", true);
                request.setAttribute("pageTitle", "Modifier Reçu Médical");
                request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            request.setAttribute("pageTitle", "Modifier Reçu Médical");
            request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/form.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    private void deleteReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            boolean success = receiptService.deleteReceipt(id);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Reçu supprimé avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Erreur lors de la suppression");
            }
            
            response.sendRedirect(request.getContextPath() + "/medical-receipts");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medical-receipts");
        }
    }

    // ========== API ENDPOINTS ==========

    private void handleApiGet(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            if (pathInfo.equals("/api/receipts")) {
                List<MedicalReceipt> receipts = receiptService.getAllReceipts();
                List<MedicalReceiptDTO> dtos = receipts.stream()
                        .map(MedicalReceiptDTO::new)
                        .collect(Collectors.toList());
                response.getWriter().write(gson.toJson(dtos));
                
            } else if (pathInfo.matches("/api/receipts/\\d+")) {
                Integer id = Integer.parseInt(pathInfo.substring(pathInfo.lastIndexOf("/") + 1));
                MedicalReceipt receipt = receiptService.getReceiptById(id);
                
                if (receipt != null) {
                    response.getWriter().write(gson.toJson(new MedicalReceiptDTO(receipt)));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Reçu non trouvé\"}");
                }
                
            } else if (pathInfo.equals("/api/generate-number")) {
                String number = receiptService.generateReceiptNumber();
                response.getWriter().write("{\"receiptNumber\":\"" + number + "\"}");
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Endpoint non trouvé\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void handleApiPost(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            if (pathInfo.equals("/api/convert-amount")) {
                String amountStr = request.getParameter("amount");
                double amount = Double.parseDouble(amountStr);
                String words = AmountToWordsConverter.convert(amount);
                
                Map<String, String> result = new HashMap<>();
                result.put("amountInWords", words);
                response.getWriter().write(gson.toJson(result));
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Endpoint non trouvé\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // ========== MÉTHODES UTILITAIRES ==========

    private MedicalReceipt buildReceiptFromRequest(HttpServletRequest request) {
        MedicalReceipt receipt = new MedicalReceipt();
        
        receipt.setReceiptNumber(request.getParameter("receiptNumber"));
        receipt.setPatientName(request.getParameter("patientName"));
        receipt.setPatientContact(request.getParameter("patientContact"));
        receipt.setServiceType(request.getParameter("serviceType"));
        receipt.setAmount(Double.parseDouble(request.getParameter("amount")));
        receipt.setServedBy(request.getParameter("servedBy"));
        receipt.setNotes(request.getParameter("notes"));
        
        // Date du reçu (par défaut maintenant)
        String receiptDateStr = request.getParameter("receiptDate");
        if (receiptDateStr != null && !receiptDateStr.isEmpty()) {
            receipt.setReceiptDate(LocalDateTime.parse(receiptDateStr));
        }
        
        return receipt;
    }
}