package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Product;
import com.onemaster.pharmaplus.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
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
    "/products/search"
})
public class ProductServlet extends HttpServlet {
    
    private ProductService productService;
    
    @Override
    public void init() {
        productService = new ProductService();
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
            case "/products/delete":
                deleteProduct(request, response);
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
        }
    }
    
    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);
        request.setAttribute("totalProducts", productService.getTotalProducts());
        
        // Récupérer les produits en rupture de stock
        List<Product> lowStockProducts = productService.getLowStockProducts();
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("pageTitle", "Liste Produit");
        request.setAttribute("contentPage", "/WEB-INF/views/products/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Nouveau Produit");
        request.setAttribute("contentPage", "/WEB-INF/views/products/add.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(id);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.setAttribute("pageTitle", "Liste Produit");
                request.setAttribute("contentPage", "/WEB-INF/views/products/edit.jsp");
                request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        }
    }
    
    private void addProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Product product = new Product();
            product.setProductName(request.getParameter("productName"));
            product.setGenericName(request.getParameter("genericName"));
            
            if (!request.getParameter("categoryId").isEmpty()) {
                product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            }
            
            product.setManufacturer(request.getParameter("manufacturer"));
            product.setDosageForm(request.getParameter("dosageForm"));
            product.setStrength(request.getParameter("strength"));
            product.setUnitOfMeasure(request.getParameter("unitOfMeasure"));
            product.setRequiresPrescription(Boolean.parseBoolean(request.getParameter("requiresPrescription")));
            product.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
            product.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
            product.setReorderLevel(Integer.parseInt(request.getParameter("reorderLevel")));
            product.setBarcode(request.getParameter("barcode"));
            product.setIsActive(true);
            
            productService.addProduct(product);
            
            response.sendRedirect(request.getContextPath() + "/products?success=Produit+ajouté+avec+succès");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("pageTitle", "Liste Produit");
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
                
                if (!request.getParameter("categoryId").isEmpty()) {
                    product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                }
                
                product.setManufacturer(request.getParameter("manufacturer"));
                product.setDosageForm(request.getParameter("dosageForm"));
                product.setStrength(request.getParameter("strength"));
                product.setUnitOfMeasure(request.getParameter("unitOfMeasure"));
                product.setRequiresPrescription(Boolean.parseBoolean(request.getParameter("requiresPrescription")));
                product.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
                product.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
                product.setReorderLevel(Integer.parseInt(request.getParameter("reorderLevel")));
                product.setBarcode(request.getParameter("barcode"));
                
                productService.updateProduct(product);
                
                response.sendRedirect(request.getContextPath() + "/products?success=Produit+mis+à+jour");
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=Produit+non+trouvé");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            productService.deleteProduct(id);
            
            response.sendRedirect(request.getContextPath() + "/products?success=Produit+suprimé");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products?error=ID+invalide");
        }
    }
    
    private void searchProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("q");
        List<Product> products = productService.searchProductsByName(searchTerm);
        
        request.setAttribute("products", products);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("resultCount", products.size());
        request.setAttribute("pageTitle", "Liste Produit");
        request.setAttribute("contentPage", "/WEB-INF/views/products/list.jsp");
        request.getRequestDispatcher("/WEB-INF/layout.jsp").forward(request, response);
    }
}