package com.onemaster.pharmaplus.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CacheControlFilter implements Filter {
    
    private String cacheControl;
    
    @Override
    public void init(FilterConfig filterConfig) {
        this.cacheControl = filterConfig.getInitParameter("cacheControl");
        if (this.cacheControl == null) {
            this.cacheControl = "no-cache, no-store, must-revalidate";
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Désactiver le cache
        res.setHeader("Cache-Control", cacheControl);
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}