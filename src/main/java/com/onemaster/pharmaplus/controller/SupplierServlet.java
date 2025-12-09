package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Supplier;
import com.onemaster.pharmaplus.service.SupplierService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupplierServlet", urlPatterns = {"/suppliers", "/suppliers/*"})
public class SupplierServlet extends HttpServlet {
    
    private SupplierService supplierService;
    
    @Override
    public void init() {
        supplierService = new SupplierService();
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
                case "/add":
                    showAddForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/delete":
                    deleteSupplier(request, response);
                    break;
                case "/toggle-status":
                    toggleSupplierStatus(request, response);
                    break;
                default:
                    listSuppliers(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/suppliers");
        }
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
                case "/add":
                    addSupplier(request, response);
                    break;
                case "/edit":
                    updateSupplier(request, response);
                    break;
                default:
                    listSuppliers(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/suppliers");
        }
    }
    
    private void listSuppliers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            
            List<Supplier> suppliers;
            
            if (search != null && !search.trim().isEmpty()) {
                suppliers = supplierService.searchSuppliers(search);
            } else if (status != null && !status.trim().isEmpty()) {
                if ("active".equals(status)) {
                    suppliers = supplierService.getActiveSuppliers();
                } else {
                    suppliers = supplierService.getAllSuppliers();
                }
            } else {
                suppliers = supplierService.getAllSuppliers();
            }
            
            // Calculer les statistiques
            int totalSuppliers = suppliers.size();
            int activeSuppliers = supplierService.getActiveSuppliers().size();
            int localSuppliers = 0; // À implémenter dans DAO si nécessaire
            int totalProducts = 0;
            
            for (Supplier supplier : suppliers) {
                if ("France".equalsIgnoreCase(supplier.getCountry())) {
                    localSuppliers++;
                }
                totalProducts += supplierService.getSupplierProductCount(supplier.getSupplierId());
            }
            
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("totalSuppliers", totalSuppliers);
            request.setAttribute("activeSuppliers", activeSuppliers);
            request.setAttribute("localSuppliers", localSuppliers);
            request.setAttribute("productCount", totalProducts);
            request.setAttribute("pageTitle", "Gestion des Fournisseurs");
            request.setAttribute("contentPage", "/WEB-INF/views/suppliers/list.jsp");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement des fournisseurs", e);
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("pageTitle", "Ajouter un Fournisseur");
        request.setAttribute("contentPage", "/WEB-INF/views/suppliers/add.jsp");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierService.getSupplierById(supplierId);
            
            if (supplier != null) {
                request.setAttribute("supplier", supplier);
                request.setAttribute("pageTitle", "Modifier le Fournisseur");
                request.setAttribute("contentPage", "/WEB-INF/views/suppliers/edit.jsp");
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/suppliers?error=Fournisseur+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/suppliers?error=ID+fournisseur+invalide");
        }
    }
    
    private void addSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Supplier supplier = extractSupplierFromRequest(request);
            
            supplierService.addSupplier(supplier);
            
            response.sendRedirect(request.getContextPath() + 
                                "/suppliers?success=Fournisseur+ajouté+avec+succès");
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("supplier", extractSupplierFromRequest(request));
            request.setAttribute("pageTitle", "Ajouter un Fournisseur");
            request.setAttribute("contentPage", "/WEB-INF/views/suppliers/add.jsp");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = extractSupplierFromRequest(request);
            supplier.setSupplierId(supplierId);
            
            // Garder le statut actuel si non spécifié
            Supplier existingSupplier = supplierService.getSupplierById(supplierId);
            if (existingSupplier != null && request.getParameter("isActive") == null) {
                supplier.setIsActive(existingSupplier.getIsActive());
            } else {
                String isActiveParam = request.getParameter("isActive");
                supplier.setIsActive(isActiveParam != null && ("on".equals(isActiveParam) || "true".equals(isActiveParam)));
            }
            
            supplierService.updateSupplier(supplier);
            
            response.sendRedirect(request.getContextPath() + 
                                "/suppliers?success=Fournisseur+mis+à+jour+avec+succès");
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("supplier", extractSupplierFromRequest(request));
            request.setAttribute("pageTitle", "Modifier le Fournisseur");
            request.setAttribute("contentPage", "/WEB-INF/views/suppliers/edit.jsp");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            
            supplierService.deleteSupplier(supplierId);
            
            response.sendRedirect(request.getContextPath() + 
                                "/suppliers?success=Fournisseur+supprimé+avec+succès");
            
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/suppliers?error=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + 
                                "/suppliers?error=Erreur+lors+de+la+suppression");
        }
    }
    
    private void toggleSupplierStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            String action = request.getParameter("action");
            
            boolean activate = "activate".equals(action);
            supplierService.toggleSupplierStatus(supplierId, activate);
            
            String message = activate ? "Fournisseur+activé+avec+succès" : "Fournisseur+désactivé+avec+succès";
            response.sendRedirect(request.getContextPath() + "/suppliers?success=" + message);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/suppliers?error=ID+fournisseur+invalide");
        }
    }
    
    private Supplier extractSupplierFromRequest(HttpServletRequest request) {
        Supplier supplier = new Supplier();
        
        supplier.setSupplierName(request.getParameter("supplierName"));
        supplier.setContactPerson(request.getParameter("contactPerson"));
        supplier.setPhone(request.getParameter("phone"));
        supplier.setEmail(request.getParameter("email"));
        supplier.setAddress(request.getParameter("address"));
        supplier.setCity(request.getParameter("city"));
        supplier.setCountry(request.getParameter("country"));
        supplier.setBarcode(request.getParameter("barcode"));
        
        // Niveau de réapprovisionnement
        try {
            String reorderLevelStr = request.getParameter("reorderLevel");
            if (reorderLevelStr != null && !reorderLevelStr.trim().isEmpty()) {
                supplier.setReorderLevel(Integer.parseInt(reorderLevelStr));
            } else {
                supplier.setReorderLevel(10); // Valeur par défaut
            }
        } catch (NumberFormatException e) {
            supplier.setReorderLevel(10);
        }
        
        // Statut actif
        String isActiveParam = request.getParameter("isActive");
        supplier.setIsActive(isActiveParam != null && ("on".equals(isActiveParam) || "true".equals(isActiveParam)));
        
        return supplier;
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