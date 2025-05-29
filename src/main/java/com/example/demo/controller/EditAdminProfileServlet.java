package com.example.demo.controller;

import com.example.demo.dao.UserDAO;
import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Base64;

@WebServlet(name = "EditAdminProfileServlet", value = "/EditAdminProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB threshold before writing to disk
        maxFileSize = 1024 * 1024 * 5,   // Max file size 5MB per upload
        maxRequestSize = 1024 * 1024 * 10 // Max request size 10MB total
)
public class EditAdminProfileServlet extends HttpServlet {

    /**
     * Handles GET request to display the admin profile edit form.
     * Checks if the user is authenticated, loads the current user data,
     * converts profile image to Base64 string if available for displaying in the form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify user is authenticated; redirect to login if not
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get current logged-in user
        UserModel user = AuthService.getCurrentUser(request);
        request.setAttribute("user", user);

        // Convert the user's image byte array to Base64 string for display in the JSP
        if (user.getImage() != null && user.getImage().length > 0) {
            String base64Image = Base64.getEncoder().encodeToString(user.getImage());
            request.setAttribute("base64Image", base64Image);
        }

        // Forward request to the JSP for rendering the profile edit form
        request.getRequestDispatcher("/WEB-INF/views/edit-admin-profile.jsp").forward(request, response);
    }

    /**
     * Handles POST request to update the admin profile.
     * Validates input, handles profile picture upload, manages password change logic,
     * and updates the user record in the database.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify user is authenticated; redirect to login if not
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("user");
        UserModel updatedUser = new UserModel();

        // Retrieve form input values
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Handle profile picture upload (multipart/form-data)
        Part filePart = request.getPart("profilePicture");
        byte[] imageBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            imageBytes = filePart.getInputStream().readAllBytes();
        }

        // Check if the user is attempting to change their password
        boolean changingPassword = (currentPassword != null && !currentPassword.isEmpty())
                || (newPassword != null && !newPassword.isEmpty())
                || (confirmPassword != null && !confirmPassword.isEmpty());

        if (changingPassword) {
            // Verify that the current password entered matches the stored password
            if (!currentUser.getPassword().equals(currentPassword)) {
                session.setAttribute("error", "Current password is incorrect");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Check that the new password and confirm password fields match
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords don't match");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Enforce minimum password length
            if (newPassword.length() < 8) {
                session.setAttribute("error", "Password must be at least 8 characters");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Set the new password to be updated
            updatedUser.setPassword(newPassword);
        }

        // Set updated user details
        updatedUser.setId(currentUser.getId()); // Preserve user ID
        updatedUser.setName(name);
        updatedUser.setEmail(email);
        updatedUser.setRole(currentUser.getRole()); // Role remains unchanged
        updatedUser.setImage(imageBytes != null ? imageBytes : currentUser.getImage());

        // Update the user in the database (passing whether password changed)
        boolean updated = UserDAO.updateUser(updatedUser, changingPassword);

        if (updated) {
            // Update session user data (excluding password for security)
            currentUser.setName(updatedUser.getName());
            currentUser.setEmail(updatedUser.getEmail());
            currentUser.setImage(updatedUser.getImage());
            session.setAttribute("user", currentUser);

            // Set success message and redirect to user dashboard
            session.setAttribute("success", "Profile updated successfully");
            response.sendRedirect("UserDashboardServlet");
        } else {
            // Set error message and redirect back to edit form
            session.setAttribute("error", "Failed to update profile");
            response.sendRedirect("EditProfileServlet");
        }
    }
}
