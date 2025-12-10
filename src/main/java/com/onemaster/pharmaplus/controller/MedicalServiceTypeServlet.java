package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.MedicalServiceType;
import com.onemaster.pharmaplus.service.MedicalServiceTypeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/medical-receipts/services/*")
public class MedicalServiceTypeServlet extends HttpServlet {
    
    private MedicalServiceTypeService serviceTypeService;
    
    @Override
    public void init() {
        serviceTypeService = new MedicalServiceTypeService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getAction(request);
        
        switch (action) {
            case "list":
                listServiceTypes(request, response);
                break;
            case "manage":
                showManagePage(request, response);
                break;
            default:
                listServiceTypes(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getAction(request);
        
        switch (action) {
            case "create":
                createServiceType(request, response);
                break;
            case "update":
                updateServiceType(request, response);
                break;
            case "delete":
                deleteServiceType(request, response);
                break;
            case "toggle":
                toggleServiceType(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non supportée");
                break;
        }
    }
    
    private String getAction(HttpServletRequest request) {
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            return "list";
        }
        String[] parts = path.substring(1).split("/");
        return parts.length > 0 ? parts[0] : "list";
    }
    
    private void listServiceTypes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<MedicalServiceType> serviceTypes = serviceTypeService.getAllServiceTypes();
        request.setAttribute("serviceTypes", serviceTypes);
        
        // Pour AJAX, retourner JSON
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            // Ici vous pouvez utiliser Gson pour convertir en JSON
            // Pour l'instant, on redirige vers la page normale
            request.getRequestDispatcher("/WEB-INF/views/medical-receipts/service-types-list.jsp")
                   .include(request, response);
        } else {
            request.setAttribute("pageTitle", "Gestion des Services Médicaux");
            request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/service-types.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }
    
    private void showManagePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<MedicalServiceType> serviceTypes = serviceTypeService.getAllServiceTypes();
        List<String> categories = serviceTypeService.getAllCategories();
        
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("categories", categories);
        
        request.setAttribute("pageTitle", "Gestion des Services Médicaux");
        request.setAttribute("contentPage", "/WEB-INF/views/medical-receipts/manage-services.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
    
    private void createServiceType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            MedicalServiceType serviceType = new MedicalServiceType();
            
            serviceType.setServiceCode(request.getParameter("serviceCode").toUpperCase());
            serviceType.setServiceName(request.getParameter("serviceName"));
            serviceType.setServiceCategory(request.getParameter("serviceCategory"));
            
            String priceStr = request.getParameter("defaultPrice");
            if (priceStr != null && !priceStr.isEmpty()) {
                serviceType.setDefaultPrice(Double.parseDouble(priceStr));
            }
            
            String isActiveStr = request.getParameter("isActive");
            serviceType.setIsActive(isActiveStr != null && isActiveStr.equals("on"));
            
            serviceType.setDescription(request.getParameter("description"));
            
            Integer serviceId = serviceTypeService.saveServiceType(serviceType);
            
            if (serviceId != null) {
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    // Retourner JSON pour AJAX
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"Service créé avec succès\", \"id\": " + serviceId + "}");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                        "/medical-receipts/services/manage?success=Service+créé+avec+succès");
                }
            } else {
                throw new Exception("Échec de la création du service");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Erreur: " + e.getMessage() + "\"}");
            } else {
                request.setAttribute("error", "Erreur: " + e.getMessage());
                showManagePage(request, response);
            }
        }
    }
    
    private void updateServiceType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Integer serviceId = Integer.parseInt(request.getParameter("serviceId"));
            MedicalServiceType serviceType = serviceTypeService.getServiceTypeById(serviceId);
            
            if (serviceType != null) {
                serviceType.setServiceName(request.getParameter("serviceName"));
                serviceType.setServiceCategory(request.getParameter("serviceCategory"));
                
                String priceStr = request.getParameter("defaultPrice");
                if (priceStr != null && !priceStr.isEmpty()) {
                    serviceType.setDefaultPrice(Double.parseDouble(priceStr));
                }
                
                String isActiveStr = request.getParameter("isActive");
                serviceType.setIsActive(isActiveStr != null && isActiveStr.equals("on"));
                
                serviceType.setDescription(request.getParameter("description"));
                
                boolean updated = serviceTypeService.updateServiceType(serviceType);
                
                if (updated) {
                    if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\": true, \"message\": \"Service mis à jour avec succès\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + 
                            "/medical-receipts/services/manage?success=Service+mis+à+jour+avec+succès");
                    }
                } else {
                    throw new Exception("Échec de la mise à jour");
                }
            } else {
                throw new Exception("Service non trouvé");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Erreur: " + e.getMessage() + "\"}");
            } else {
                request.setAttribute("error", "Erreur: " + e.getMessage());
                showManagePage(request, response);
            }
        }
    }
    
    private void deleteServiceType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Integer serviceId = Integer.parseInt(request.getParameter("id"));
            boolean deleted = serviceTypeService.deleteServiceType(serviceId);
            
            if (deleted) {
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"Service supprimé avec succès\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                        "/medical-receipts/services/manage?success=Service+supprimé+avec+succès");
                }
            } else {
                throw new Exception("Échec de la suppression");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Erreur: " + e.getMessage() + "\"}");
            } else {
                request.setAttribute("error", "Erreur: " + e.getMessage());
                showManagePage(request, response);
            }
        }
    }
    
    private void toggleServiceType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Integer serviceId = Integer.parseInt(request.getParameter("id"));
            String action = request.getParameter("action");
            
            boolean success = false;
            
            if ("activate".equals(action)) {
                success = serviceTypeService.activateServiceType(serviceId);
            } else if ("deactivate".equals(action)) {
                success = serviceTypeService.deactivateServiceType(serviceId);
            }
            
            if (success) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Statut modifié avec succès\"}");
            } else {
                throw new Exception("Échec de la modification du statut");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Erreur: " + e.getMessage() + "\"}");
        }
    }
}