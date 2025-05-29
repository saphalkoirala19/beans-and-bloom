//package com.example.demo.filters;
//
//import com.example.demo.models.UserModel;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
///**
// * AuthenticationFilter
// *
// * Protects user/admin dashboard servlets and pages.
// * Allows access to public resources without login.
// * Redirects unauthenticated users to LoginServlet.
// */
//@WebFilter(urlPatterns = {"/UserDashboardServlet", "/AdminDashboardServlet", "/WEB-INF/views/user-dashboard.jsp", "/WEB-INF/views/admin-dashboard.jsp"})
//public class AuthenticationFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest request = (HttpServletRequest) req;
//        HttpServletResponse response = (HttpServletResponse) res;
//
//        String path = request.getServletPath();
//
//        // List of URLs to exclude from authentication
//        boolean isLoginRequest = path.equals("/LoginServlet") || path.equals("/login.jsp");
//
//        HttpSession session = request.getSession(false);
//        boolean isLoggedIn = (session != null && session.getAttribute("currentUser") != null);
//
//        if (isLoggedIn || isLoginRequest) {
//            // User logged in or requesting login page -> proceed
//            chain.doFilter(req, res);
//        } else {
//            // Not logged in and not requesting login -> redirect to login
//            response.sendRedirect("LoginServlet");
//        }
//    }
//}
