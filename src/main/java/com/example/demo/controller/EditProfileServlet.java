package com.example.demo.controller;

import com.example.demo.dao.UserDAO;
import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Base64;

@WebServlet(name = "EditProfileServlet", value = "/EditProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB threshold before writing to disk
        maxFileSize = 1024 * 1024 * 5,   // Max file size per upload: 5MB
        maxRequestSize = 1024 * 1024 * 10 // Max total request size: 10MB
)
public class EditProfileServlet extends HttpServlet {

    /**
     * Handles GET requests to show the profile edit page.
     * Checks if user is authenticated, fetches current user info,
     * converts user image to Base64 string for display,
     * and forwards to the JSP view.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to login if user not authenticated
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get current logged-in user info
        UserModel user = AuthService.getCurrentUser(request);
        request.setAttribute("user", user);

        // Convert user image bytes to Base64 string for display on page
        if (user.getImage() != null && user.getImage().length > 0) {
            String base64Image = Base64.getEncoder().encodeToString(user.getImage());
            request.setAttribute("base64Image", base64Image);
        }

        // Forward request to JSP page for profile editing
        request.getRequestDispatcher("/WEB-INF/views/edit-profile.jsp").forward(request, response);
    }

    /**
     * Handles POST requests to update user profile.
     * Validates authentication, processes form inputs including optional image upload,
     * handles optional password change with validation,
     * updates user in DB, and manages success/error feedback.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to login if user not authenticated
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("user");
        UserModel updatedUser = new UserModel();

        // Retrieve form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Handle profile picture upload
        Part filePart = request.getPart("profilePicture");
        byte[] imageBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            imageBytes = filePart.getInputStream().readAllBytes();
        }

        // Check if user is attempting to change password
        boolean changingPassword = (currentPassword != null && !currentPassword.isEmpty())
                || (newPassword != null && !newPassword.isEmpty())
                || (confirmPassword != null && !confirmPassword.isEmpty());

        if (changingPassword) {
            // Verify current password correctness
            if (!currentUser.getPassword().equals(currentPassword)) {
                session.setAttribute("error", "Current password is incorrect");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Check if new password and confirmation match
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords don't match");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Validate password length
            if (newPassword.length() < 8) {
                session.setAttribute("error", "Password must be at least 8 characters");
                response.sendRedirect("EditProfileServlet");
                return;
            }

            // Set new password in updated user model
            updatedUser.setPassword(newPassword);
        }

        // Set remaining user info for update
        updatedUser.setId(currentUser.getId());
        updatedUser.setName(name);
        updatedUser.setEmail(email);
        updatedUser.setRole(currentUser.getRole()); // Preserve role
        // Use new image if uploaded; else keep existing image
        updatedUser.setImage(imageBytes != null ? imageBytes : currentUser.getImage());

        // Call DAO to update user in database
        boolean updated = UserDAO.updateUser(updatedUser, changingPassword);

        if (updated) {
            // Update session with new user data (except password for security)
            currentUser.setName(updatedUser.getName());
            currentUser.setEmail(updatedUser.getEmail());
            currentUser.setImage(updatedUser.getImage());
            session.setAttribute("user", currentUser);

            // Set success message and redirect to dashboard
            session.setAttribute("success", "Profile updated successfully");
            response.sendRedirect("UserDashboardServlet");
        } else {
            // Set error message and redirect back to edit page on failure
            session.setAttribute("error", "Failed to update profile");
            response.sendRedirect("EditProfileServlet");
        }
    }
}
