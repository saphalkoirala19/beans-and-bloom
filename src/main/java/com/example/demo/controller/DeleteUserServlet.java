package com.example.demo.controller;

import com.example.demo.dao.UserDAO;
import com.example.demo.services.AuthService;
import com.example.demo.models.UserModel;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "DeleteUserServlet", value = "/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    /**
     * Handles POST requests to delete a user.
     * Only authenticated admins can delete users.
     * Admins cannot delete their own account.
     * Redirects to AdminDashboardServlet with success or error messages.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is authenticated and is an admin
        if (!AuthService.isAuthenticated(request) || !AuthService.isAdmin(request)) {
            // Redirect unauthorized users to login page
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get the user ID parameter from the request
        String userIdStr = request.getParameter("id");

        // If no user ID provided, redirect with error message
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect("AdminDashboardServlet?error=No+user+ID+provided");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Get the current logged-in user
            UserModel currentUser = AuthService.getCurrentUser(request);

            // Prevent admin from deleting their own account
            if (currentUser.getId() == userId) {
                response.sendRedirect("AdminDashboardServlet?error=Cannot+delete+your+own+account");
                return;
            }

            // Attempt to delete the user from the database
            boolean success = UserDAO.deleteUser(userId);

            if (success) {
                // Redirect with success message if deletion was successful
                response.sendRedirect("AdminDashboardServlet?success=User+deleted+successfully");
            } else {
                // Redirect with error message if deletion failed
                response.sendRedirect("AdminDashboardServlet?error=Failed+to+delete+user");
            }

        } catch (NumberFormatException e) {
            // Redirect with error if user ID is invalid
            response.sendRedirect("AdminDashboardServlet?error=Invalid+user+ID");
        }
    }
}
