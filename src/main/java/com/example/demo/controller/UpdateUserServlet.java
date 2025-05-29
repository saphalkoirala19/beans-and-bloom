package com.example.demo.controller;

import com.example.demo.dao.UserDAO;
import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Base64;

/**
 * UpdateUserServlet
 *
 * Handles displaying and updating user details by admin.
 * Supports image upload and form submission.
 */
@WebServlet(name = "UpdateUserServlet", value = "/UpdateUserServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,       // 1MB before writing to disk
        maxFileSize = 1024 * 1024 * 5,         // Max image file size 5MB
        maxRequestSize = 1024 * 1024 * 10      // Max request size 10MB
)
public class UpdateUserServlet extends HttpServlet {

    /**
     * Shows the edit user form to admin.
     * Loads user data by ID and converts image to Base64 string if available.
     * Redirects if user not found or unauthorized access.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check admin authentication and authorization
        if (!AuthService.isAuthenticated(request) || !AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get user ID parameter
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect("AdminDashboardServlet");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            UserModel userToEdit = UserDAO.getUserById(userId);

            if (userToEdit != null) {
                // Convert image bytes to Base64 string if image exists
                if (userToEdit.getImage() != null && userToEdit.getImage().length > 0) {
                    String base64Image = Base64.getEncoder().encodeToString(userToEdit.getImage());
                    request.setAttribute("base64Image", base64Image);
                }

                // Set user attribute and forward to edit page
                request.setAttribute("userToEdit", userToEdit);
                request.getRequestDispatcher("/WEB-INF/views/edit-user.jsp").forward(request, response);
            } else {
                // User not found
                response.sendRedirect("AdminDashboardServlet?error=User+not+found");
            }
        } catch (NumberFormatException e) {
            // Invalid user ID format
            response.sendRedirect("AdminDashboardServlet?error=Invalid+user+ID");
        }
    }

    /**
     * Processes the form submission to update user details.
     * Validates admin access, updates user info in database.
     * Redirects to dashboard with success or error message.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check admin authentication and authorization
        if (!AuthService.isAuthenticated(request) || !AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get uploaded image part (not currently used for update)
        Part filePart = request.getPart("image");

        // Get form parameters
        String userIdStr = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        try {
            int userId = Integer.parseInt(userIdStr);
            UserModel userToUpdate = UserDAO.getUserById(userId);

            if (userToUpdate != null) {
                // Update user fields
                userToUpdate.setName(name);
                userToUpdate.setEmail(email);
                userToUpdate.setRole(UserModel.Role.valueOf(role));

                // Currently no password change
                boolean changingPassword = false;

                // Update user profile in database
                boolean success = UserDAO.updateProfile(userToUpdate, changingPassword);

                if (success) {
                    response.sendRedirect("AdminDashboardServlet?success=User+updated+successfully");
                } else {
                    response.sendRedirect("AdminDashboardServlet?error=Failed+to+update+user");
                }
            } else {
                response.sendRedirect("AdminDashboardServlet?error=User+not+found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminDashboardServlet?error=Invalid+user+ID");
        }
    }
}
