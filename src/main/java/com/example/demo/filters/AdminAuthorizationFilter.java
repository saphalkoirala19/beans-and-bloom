//package com.example.demo.filters;
//
//import com.example.demo.models.UserModel;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//
///**
// * AdminAuthorizationFilter
// *
// * Protects admin-only resources by checking if the logged-in user has admin role.
// * Redirects unauthorized or unauthenticated users to the login page.
// */
//@WebFilter(urlPatterns = {
//        "/AdminDashboardServlet",
//        "/WEB-INF/views/admin-dashboard.jsp"
//})
//public class AdminAuthorizationFilter implements Filter {
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // Optional initialization code, if needed
//    }
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest request = (HttpServletRequest) req;
//        HttpServletResponse response = (HttpServletResponse) res;
//
//        // Get existing session, do not create a new one
//        HttpSession session = request.getSession(false);
//
//        if (session != null) {
//            UserModel user = (UserModel) session.getAttribute("currentUser");
//
//            // Check if user exists and has admin role
//            if (user != null && user.getRole() == UserModel.Role.admin) {
//                // User is admin - allow request to proceed
//                chain.doFilter(req, res);
//                return;
//            }
//        }
//
//        // User not logged in or not admin - redirect to login page
//        response.sendRedirect("LoginServlet");
//    }
//
//    @Override
//    public void destroy() {
//        // Optional cleanup code, if needed
//    }
//}
