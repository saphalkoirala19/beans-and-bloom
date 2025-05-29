package com.example.demo.controller;

import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import com.example.demo.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Base64;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminDashboardServlet
 *
 * This servlet handles the admin dashboard functionality. It's responsible for
 * displaying the admin dashboard and processing admin-specific actions.
 *
 * Session management implementation:
 * 1. Checks if the user is authenticated using AuthService
 * 2. Verifies that the user has the admin role
 * 3. If not authenticated or not an admin, redirects to the login page
 */
@WebServlet(name = "AdminDashboardServlet", value = "/AdminDashboardServlet")
public class AdminDashBoardServlet extends HttpServlet {

    /**
     * Handles GET requests to the AdminDashboardServlet
     *
     * This method checks if the user is authenticated and has admin role.
     * If so, it displays the admin dashboard. Otherwise, it redirects to the login page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Step 1: Validate authentication and admin role
        if (AuthService.isAuthenticated(request) && AuthService.isAdmin(request)) {
            // Step 2: Fetch current user from session
            UserModel user = AuthService.getCurrentUser(request);

            // Step 3: Attach user to request for use in JSP
            request.setAttribute("user", user);

            // Step 4: Retrieve all users for admin management panel
            List<UserModel> allUsers = UserDAO.getAllUsers();
            request.setAttribute("allUsers", allUsers);

            // Step 5: Convert user image to Base64 if available (for HTML <img> display)
            if (user.getImage() != null && user.getImage().length > 0) {
                String base64Image = Base64.getEncoder().encodeToString(user.getImage());
                request.setAttribute("base64Image", base64Image);
            }

            // Step 6: Forward request to admin dashboard JSP
            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        } else {
            // Redirect to login page if not authorized
            response.sendRedirect("LoginServlet");
        }
    }

    /**
     * Handles POST requests to the AdminDashboardServlet
     *
     * This method verifies that the user is authenticated and has admin role,
     * then processes any admin-specific form submissions or actions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Same access check as in doGet
        if (!AuthService.isAuthenticated(request) || !AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // No specific POST actions yet — fallback to showing dashboard
        doGet(request, response);
    }
}
