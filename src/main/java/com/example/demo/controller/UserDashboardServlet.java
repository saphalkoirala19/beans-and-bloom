package com.example.demo.controller;

import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Base64;

/**
 * This servlet shows the user dashboard page.
 *
 * If the user is logged in and is a regular user, it shows their info.
 * If the user is an admin, it sends them to the admin dashboard.
 * If the user is not logged in, it sends them to the login page.
 */
@WebServlet(name = "UserDashboardServlet", value = "/UserDashboardServlet")
public class UserDashboardServlet extends HttpServlet {

    /**
     * Handles loading the user dashboard page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (AuthService.isAuthenticated(request)) {
            UserModel user = AuthService.getCurrentUser(request);

            // If admin, go to admin dashboard instead
            if (user.getRole() != UserModel.Role.user) {
                response.sendRedirect("AdminDashboardServlet");
                return;
            }

            // Set user info for the page
            request.setAttribute("user", user);

            // Convert profile image to Base64 if it exists
            if (user.getImage() != null && user.getImage().length > 0) {
                String base64Image = Base64.getEncoder().encodeToString(user.getImage());
                request.setAttribute("base64Image", base64Image);
            }

            // Show the user dashboard page
            request.getRequestDispatcher("/WEB-INF/views/user-dashboard.jsp").forward(request, response);
        } else {
            // If not logged in, go to login page
            response.sendRedirect("LoginServlet");
        }
    }

    /**
     * Handles form submissions on the dashboard.
     * Currently, it just reloads the dashboard page.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }
        doGet(request, response);
    }
}
