package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Inventory;
import com.onemaster.pharmaplus.service.InventoryService;
import com.onemaster.pharmaplus.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = {
        "/inventory",
        "/inventory/add",
        "/inventory/edit",
        "/inventory/update",
        "/inventory/delete",
        "/inventory/expiring",
        "/inventory/expired",
        "/inventory/lowstock",
        "/inventory/view"
})
public class InventoryServlet extends HttpServlet {

    private InventoryService inventoryService;
    private ProductService productService;

    @Override
    public void init() {
        inventoryService = new InventoryService();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/inventory":
                listInventory(request, response);
                break;
            case "/inventory/add":
                showAddForm(request, response);
                break;
            case "/inventory/edit":
                showEditForm(request, response);
                break;
            case "/inventory/delete":
                deleteInventory(request, response);
                break;
            case "/inventory/expiring":
                showExpiringSoon(request, response);
                break;
            case "/inventory/expired":
                showExpired(request, response);
                break;
            case "/inventory/lowstock":
                showLowStock(request, response);
                break;
            case "/inventory/view":
                viewInventory(request, response);
                break;
            default:
                listInventory(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        if ("/inventory/add".equals(action)) {
            addInventory(request, response);
        } else if ("/inventory/update".equals(action)) {
            updateInventory(request, response);
        }
    }

    private void listInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Inventory> inventory = inventoryService.getAllInventory();
        request.setAttribute("inventoryList", inventory);
        request.setAttribute("totalItems", inventory.size());
        request.setAttribute("pageTitle", "Liste Inventaire");
        request.setAttribute("contentPage", "/WEB-INF/views/inventory/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Passer la liste des produits pour le formulaire
        request.setAttribute("products", productService.getAllProducts());
        request.setAttribute("pageTitle", "Nouvel Inventaire");
        request.setAttribute("contentPage", "/WEB-INF/views/inventory/add.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            Inventory inventory = inventoryService.getInventoryById(id);

            if (inventory != null) {
                request.setAttribute("inventory", inventory);
                request.setAttribute("products", productService.getAllProducts());
                request.setAttribute("pageTitle", "Modifier Inventaire");
                request.setAttribute("contentPage", "/WEB-INF/views/inventory/edit.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/inventory?error=Lot+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/inventory?error=ID+invalide");
        }
    }

    private void addInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Inventory inventory = new Inventory();
            inventory.setProductId(Integer.parseInt(request.getParameter("productId")));
            inventory.setBatchNumber(request.getParameter("batchNumber"));

            if (request.getParameter("supplierId") != null && !request.getParameter("supplierId").isEmpty()) {
                inventory.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            }

            inventory.setQuantityInStock(Integer.parseInt(request.getParameter("quantity")));
            inventory.setQuantityReserved(0);

            // Dates
            if (request.getParameter("manufacturingDate") != null &&
                    !request.getParameter("manufacturingDate").isEmpty()) {
                inventory.setManufacturingDate(LocalDate.parse(request.getParameter("manufacturingDate")));
            }

            inventory.setExpiryDate(LocalDate.parse(request.getParameter("expiryDate")));

            if (request.getParameter("purchasePrice") != null &&
                    !request.getParameter("purchasePrice").isEmpty()) {
                inventory.setPurchasePrice(Double.parseDouble(request.getParameter("purchasePrice")));
            }

            inventory.setLocation(request.getParameter("location"));
            inventory.setReceivedDate(LocalDate.now());

            inventoryService.addInventory(inventory);

            response.sendRedirect(request.getContextPath() + "/inventory?success=Lot+ajouté+avec+succès");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("products", productService.getAllProducts());
            request.setAttribute("pageTitle", "Nouvel Inventaire");
            request.setAttribute("contentPage", "/WEB-INF/views/inventory/add.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    private void updateInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("inventoryId"));
            Inventory inventory = inventoryService.getInventoryById(id);

            if (inventory != null) {
                inventory.setProductId(Integer.parseInt(request.getParameter("productId")));
                inventory.setBatchNumber(request.getParameter("batchNumber"));

                if (request.getParameter("supplierId") != null && !request.getParameter("supplierId").isEmpty()) {
                    inventory.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
                } else {
                    inventory.setSupplierId(null);
                }

                inventory.setQuantityInStock(Integer.parseInt(request.getParameter("quantity")));

                // Dates
                if (request.getParameter("manufacturingDate") != null &&
                        !request.getParameter("manufacturingDate").isEmpty()) {
                    inventory.setManufacturingDate(LocalDate.parse(request.getParameter("manufacturingDate")));
                } else {
                    inventory.setManufacturingDate(null);
                }

                inventory.setExpiryDate(LocalDate.parse(request.getParameter("expiryDate")));

                if (request.getParameter("purchasePrice") != null &&
                        !request.getParameter("purchasePrice").isEmpty()) {
                    inventory.setPurchasePrice(Double.parseDouble(request.getParameter("purchasePrice")));
                } else {
                    inventory.setPurchasePrice(null);
                }

                inventory.setLocation(request.getParameter("location"));

                inventoryService.updateInventory(inventory);

                response.sendRedirect(request.getContextPath() + "/inventory?success=Lot+mis+à+jour");
            } else {
                response.sendRedirect(request.getContextPath() + "/inventory?error=Lot+non+trouvé");
            }

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            inventoryService.deleteInventory(id);

            response.sendRedirect(request.getContextPath() + "/inventory?success=Lot+supprimé");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/inventory?error=ID+invalide");
        }
    }

    private void showExpiringSoon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int days = 60; // Par défaut 60 jours
        if (request.getParameter("days") != null) {
            days = Integer.parseInt(request.getParameter("days"));
        }

        List<Inventory> expiring = inventoryService.getExpiringSoon(days);
        request.setAttribute("inventoryList", expiring);
        request.setAttribute("days", days);
        request.setAttribute("title", "Produits expirant dans " + days + " jours");

        request.setAttribute("pageTitle", "Liste Inventaire");
        request.setAttribute("contentPage", "/WEB-INF/views/inventory/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void viewInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            Inventory inventory = inventoryService.getInventoryById(id);

            if (inventory != null) {
                // Vous devez peut-être récupérer des informations supplémentaires
                // comme le nom du produit, fournisseur, etc.

                request.setAttribute("inventory", inventory);
                request.setAttribute("pageTitle", "Détails du Lot #" + id);
                request.setAttribute("contentPage", "/WEB-INF/views/inventory/view.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/inventory?error=Lot+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/inventory?error=ID+invalide");
        }
    }

    private void showExpired(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Inventory> expired = inventoryService.getExpiredProducts();
        request.setAttribute("inventoryList", expired);
        request.setAttribute("title", "Produits Expirés");
        request.setAttribute("pageActive","inventory");
        request.setAttribute("pageTitle", "Liste Inventaire");
        request.setAttribute("contentPage", "/WEB-INF/views/inventory/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }

    private void showLowStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int threshold = 10; // Par défaut
        if (request.getParameter("threshold") != null) {
            threshold = Integer.parseInt(request.getParameter("threshold"));
        }

        List<Inventory> lowStock = inventoryService.getLowStock(threshold);
        request.setAttribute("inventoryList", lowStock);
        request.setAttribute("threshold", threshold);
        request.setAttribute("title", "Produits en faible stock (< " + threshold + ")");

        request.setAttribute("pageTitle", "Liste Inventaire");
        request.setAttribute("contentPage", "/WEB-INF/views/inventory/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
}