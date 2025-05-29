package com.example.demo.controller;

import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * RegisterServlet
 *
 * Handles user registration.
 * Shows registration form on GET.
 * Processes registration form on POST with validation.
 * Supports profile image upload.
 */
@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold for file size before writing to disk
        maxFileSize = 1024 * 1024 * 10,       // Max file size 10MB
        maxRequestSize = 1024 * 1024 * 50     // Max request size 50MB
)
public class RegisterServlet extends HttpServlet {

    /**
     * Shows the registration form.
     * If user is logged in, can redirect to dashboard (not implemented here).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    /**
     * Processes registration form submission.
     * Validates input fields and handles profile image upload.
     * Calls AuthService to register user.
     * Redirects to login on success or shows error on failure.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm-password");
            String role = request.getParameter("role");

            // Validate name
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Name is required");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Validate email
            if (email == null || email.trim().isEmpty() || !email.contains("@")) {
                request.setAttribute("errorMessage", "Valid email is required");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Validate password
            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Password is required");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Check password confirmation
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Handle profile image upload
            Part imagePart = request.getPart("image");
            byte[] imageBytes = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                imageBytes = imagePart.getInputStream().readAllBytes();
            }

            // Register the user using AuthService
            int userID = AuthService.register(name, email, password, role, imageBytes);

            if (userID != -1) {
                // Registration success - redirect to login with message
                response.sendRedirect("LoginServlet?message=Registration+successful!+Please+login+with+your+credentials.");

                // Optional: start session and redirect to dashboard
                // Optional: set remember-me cookie
            } else {
                // Registration failed - show error
                request.setAttribute("errorMessage", "Registration failed. Email may already be in use.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Unexpected error handling
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
