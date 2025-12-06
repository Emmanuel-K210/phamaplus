package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Product;
import com.onemaster.pharmaplus.service.ProductService;
import com.onemaster.pharmaplus.service.InventoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {
        "/products",
        "/products/add",
        "/products/edit",
        "/products/update",
        "/products/delete",
        "/products/search",
        "/products/view",
        "/products/toggle-status"
})
public class ProductServlet extends BaseServlet {

    @Override
    protected void initialize() throws ServletException {
        // Vérifier que les services sont injectés
        if (!areServicesAvailable()) {
            throw new ServletException("Les services nécessaires ne sont pas disponibles");
        }
        logInfo("ProductServlet initialisé avec succès");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/products":
                listProducts(request, response);
                break;
            case "/products/add":
                showAddForm(request, response);
                break;
            case "/products/edit":
                showEditForm(request, response);
                break;
            case "/products/view":
                showProductDetails(request, response);
                break;
            case "/products/delete":
                deleteProduct(request, response);
                break;
            case "/products/toggle-status":
                toggleProductStatus(request, response);
                break;
            case "/products/search":
                searchProducts(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        if ("/products/add".equals(action)) {
            addProduct(request, response);
        } else if ("/products/update".equals(action)) {
            updateProduct(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non supportée");
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gestion de la pagination
        int page = 1;
        int pageSize = 10;

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            logWarning("Paramètre page invalide, utilisation de la valeur par défaut (1)");
        }

        // Gestion des filtres
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        try {
            // Récupérer les produits avec pagination
            List<Product> products = productService.getProductsWithPagination(page, pageSize, search, category, status);
            long totalProducts = productService.getTotalProducts(search, category, status);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            // Récupérer les statistiques
            long activeProducts = productService.getActiveProductsCount();
            long prescriptionProducts = productService.getPrescriptionProductsCount();
            double totalValue = productService.getTotalInventoryValue();

            request.setAttribute("products", products);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("prescriptionProducts", prescriptionProducts);
            request.setAttribute("totalValue", totalValue);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);

            // Récupérer les produits en rupture de stock
            List<Product> lowStockProducts = productService.getLowStockProducts();
            request.setAttribute("lowStockProducts", lowStockProducts);

            request.setAttribute("pageTitle", "Liste des Produits");
            request.setAttribute("contentPage", "/WEB-INF/views/products/list.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

        } catch (Exception e) {
            logError("Erreur lors de la récupération des produits", e);
            request.setAttribute("error", "Une erreur est survenue lors de la récupération des produits");
            request.setAttribute("pageTitle", "Erreur");
            request.setAttribute("contentPage", "/WEB-INF/views/error.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("pageTitle", "Nouveau Produit");
            request.setAttribute("contentPage", "/WEB-INF/views/products/add.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        } catch (Exception e) {
            logError("Erreur lors de l'affichage du formulaire d'ajout", e);
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+interne");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // IMPORTANT: Désactiver le cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/products?error=ID+manquant");
                return;
            }

            Integer id = Integer.parseInt(idParam);
            Product product = productService.getProductById(id);

            if (product != null) {
                request.setAttribute("product", product);
                request.setAttribute("pageTitle", "Modifier Produit: " + product.getProductName());
                request.setAttribute("contentPage", "/WEB-INF/views/products/edit.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }
        } catch (NumberFormatException e) {
            logWarning("ID produit invalide: " + request.getParameter("id"));
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        } catch (Exception e) {
            logError("Erreur lors de l'affichage du formulaire d'édition", e);
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+interne");
        }
    }

    private void showProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(id);

            if (product != null) {
                // Récupérer le stock actuel avec la méthode existante
                int currentStock = inventoryService.getTotalStockForProduct(id);

                // Ou pour le stock disponible :
                // int availableStock = inventoryService.getAvailableStockForProduct(id);

                // Vérifier le niveau de stock
                if (currentStock <= product.getReorderLevel()) {
                    request.setAttribute("lowStockWarning",
                            "Stock faible: " + currentStock + " unités restantes. Seuil de réapprovisionnement: " +
                                    product.getReorderLevel() + " unités.");
                }

                request.setAttribute("product", product);
                request.setAttribute("currentStock", currentStock);
                request.setAttribute("pageTitle", "Détails Produit: " + product.getProductName());
                request.setAttribute("contentPage", "/WEB-INF/views/products/view.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }
        } catch (NumberFormatException e) {
            logWarning("ID produit invalide pour la vue détaillée: " + request.getParameter("id"));
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        } catch (Exception e) {
            logError("Erreur lors de l'affichage des détails du produit", e);
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+interne");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Product product = new Product();
            product.setProductName(request.getParameter("productName"));
            product.setGenericName(request.getParameter("genericName"));

            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                try {
                    product.setCategoryId(Integer.parseInt(categoryIdParam));
                } catch (NumberFormatException e) {
                    logWarning("Format de categoryId invalide: " + categoryIdParam);
                }
            }

            product.setManufacturer(request.getParameter("manufacturer"));
            product.setDosageForm(request.getParameter("dosageForm"));
            product.setStrength(request.getParameter("strength"));
            product.setUnitOfMeasure(request.getParameter("unitOfMeasure"));

            // Gestion des valeurs booléennes
            String requiresPrescription = request.getParameter("requiresPrescription");
            product.setRequiresPrescription(requiresPrescription != null &&
                    (requiresPrescription.equals("true") || requiresPrescription.equals("on")));

            // Gestion des prix
            try {
                product.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
                product.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Les prix doivent être des nombres valides");
            }

            // Gestion du seuil de réapprovisionnement
            try {
                product.setReorderLevel(Integer.parseInt(request.getParameter("reorderLevel")));
            } catch (NumberFormatException e) {
                product.setReorderLevel(10); // Valeur par défaut
            }

            product.setBarcode(request.getParameter("barcode"));
            product.setIsActive(true);

            productService.addProduct(product);
            logInfo("Produit ajouté avec succès: " + product.getProductName());

            response.sendRedirect(request.getContextPath() + "/products?success=Produit+ajouté+avec+succès");

        } catch (IllegalArgumentException e) {
            logWarning("Données invalides lors de l'ajout du produit: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.setAttribute("pageTitle", "Nouveau Produit");
            request.setAttribute("contentPage", "/WEB-INF/views/products/add.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        } catch (Exception e) {
            logError("Erreur lors de l'ajout du produit", e);
            request.setAttribute("error", "Une erreur est survenue lors de l'ajout du produit: " + e.getMessage());
            request.setAttribute("pageTitle", "Nouveau Produit");
            request.setAttribute("contentPage", "/WEB-INF/views/products/add.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("productId"));
            Product product = productService.getProductById(id);

            if (product != null) {
                product.setProductName(request.getParameter("productName"));
                product.setGenericName(request.getParameter("genericName"));

                String categoryIdParam = request.getParameter("categoryId");
                if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                    try {
                        product.setCategoryId(Integer.parseInt(categoryIdParam));
                    } catch (NumberFormatException e) {
                        logWarning("Format de categoryId invalide: " + categoryIdParam);
                    }
                } else {
                    product.setCategoryId(null);
                }

                product.setManufacturer(request.getParameter("manufacturer"));
                product.setDosageForm(request.getParameter("dosageForm"));
                product.setStrength(request.getParameter("strength"));
                product.setUnitOfMeasure(request.getParameter("unitOfMeasure"));

                // Gestion des valeurs booléennes
                String requiresPrescription = request.getParameter("requiresPrescription");
                product.setRequiresPrescription(requiresPrescription != null &&
                        (requiresPrescription.equals("true") || requiresPrescription.equals("on")));

                // Gestion des prix
                try {
                    product.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
                    product.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Les prix doivent être des nombres valides");
                }

                // Gestion du seuil de réapprovisionnement
                try {
                    product.setReorderLevel(Integer.parseInt(request.getParameter("reorderLevel")));
                } catch (NumberFormatException e) {
                    product.setReorderLevel(10);
                }

                product.setBarcode(request.getParameter("barcode"));

                productService.updateProduct(product);
                logInfo("Produit mis à jour: " + product.getProductName());

                // Vérifier si on doit rediriger vers la vue
                String redirect = request.getParameter("redirect");
                if ("view".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() + "/products/view?id=" + id + "&success=Produit+mis+à+jour");
                } else {
                    response.sendRedirect(request.getContextPath() + "/products?success=Produit+mis+à+jour");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }

        } catch (IllegalArgumentException e) {
            logWarning("Données invalides lors de la mise à jour: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        } catch (Exception e) {
            logError("Erreur lors de la mise à jour du produit", e);
            request.setAttribute("error", "Une erreur est survenue lors de la mise à jour: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));

            // Vérifier s'il y a du stock
            int currentStock = inventoryService.getTotalStockForProduct(id);
            if (currentStock > 0) {
                logWarning("Tentative de suppression d'un produit avec stock: ID=" + id + ", stock=" + currentStock);
                response.sendRedirect(request.getContextPath() +
                        "/products/view?id=" + id +
                        "&error=Impossible+de+supprimer+le+produit+car+il+y+a+encore+" +
                        currentStock + "+unités+en+stock");
                return;
            }

            productService.deleteProduct(id);
            logInfo("Produit supprimé (désactivé): ID=" + id);

            // Vérifier la page de redirection
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("/products/view")) {
                response.sendRedirect(request.getContextPath() + "/products?success=Produit+supprimé+avec+succès");
            } else {
                response.sendRedirect(request.getContextPath() + "/products?success=Produit+supprimé+avec+succès");
            }

        } catch (NumberFormatException e) {
            logWarning("ID produit invalide pour la suppression: " + request.getParameter("id"));
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        } catch (Exception e) {
            logError("Erreur lors de la suppression du produit", e);
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+de+suppression");
        }
    }

    private void toggleProductStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(id);

            if (product != null) {
                // Inverser le statut
                boolean newStatus = !product.getIsActive();
                product.setIsActive(newStatus);
                productService.updateProduct(product);

                String action = newStatus ? "activé" : "désactivé";
                logInfo("Statut du produit changé: ID=" + id + ", nouveau statut=" + newStatus);

                // Vérifier la page de redirection
                String redirect = request.getParameter("redirect");
                if ("view".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() +
                            "/products/view?id=" + id +
                            "&success=Produit+" + action + "+avec+succès");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/products?success=Produit+" + action + "+avec+succès");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }

        } catch (NumberFormatException e) {
            logWarning("ID produit invalide pour le changement de statut: " + request.getParameter("id"));
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        } catch (Exception e) {
            logError("Erreur lors du changement de statut du produit", e);
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+interne");
        }
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String searchTerm = request.getParameter("q");
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            List<Product> products = productService.searchProductsByName(searchTerm);

            request.setAttribute("products", products);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("resultCount", products.size());
            request.setAttribute("pageTitle", "Recherche Produits");
            request.setAttribute("contentPage", "/WEB-INF/views/products/list.jsp");
            request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);

        } catch (Exception e) {
            logError("Erreur lors de la recherche de produits", e);
            response.sendRedirect(request.getContextPath() + "/products?error=Erreur+de+recherche");
        }
    }
}