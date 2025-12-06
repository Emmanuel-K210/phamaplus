package com.onemaster.pharmaplus.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class StaticResourceFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI();
        
        System.out.println("🔧 StaticResourceFilter - Path: " + path);
        
        // Définir les types MIME corrects
        if (path.endsWith(".css")) {
            httpResponse.setContentType("text/css; charset=UTF-8");
            System.out.println("🎨 Définition du type MIME: text/css");
        } else if (path.endsWith(".js")) {
            httpResponse.setContentType("application/javascript; charset=UTF-8");
            System.out.println("⚡ Définition du type MIME: application/javascript");
        }
        
        // Désactiver le cache pour le développement
        httpResponse.setHeader("Cache-Control", "public, max-age=0");
        httpResponse.setHeader("Pragma", "no-cache");
        
        // Laisser passer la requête
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("🔧 StaticResourceFilter initialisé");
    }
    
    @Override
    public void destroy() {
        System.out.println("🔧 StaticResourceFilter détruit");
    }
}