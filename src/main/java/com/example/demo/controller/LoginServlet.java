package com.example.demo.controller;

import com.example.demo.models.UserModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Base64;

/**
 * LoginServlet
 *
 * Handles user login functionality.
 *
 * On GET request:
 * - If user is already logged in, redirects to appropriate dashboard based on role.
 * - Otherwise, shows login page and pre-fills email if "Remember Me" cookie exists.
 *
 * On POST request:
 * - Validates user credentials.
 * - Creates session if authentication succeeds.
 * - Manages "Remember Me" cookie.
 * - Redirects user to their dashboard.
 */
@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    /**
     * Handles GET requests to display the login page or redirect logged-in users.
     *
     * @param request  HttpServletRequest object
     * @param response HttpServletResponse object
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // If user is already logged in, redirect to dashboard based on role
        if (AuthService.isAuthenticated(request)) {
            UserModel user = AuthService.getCurrentUser(request);
            if (user.getRole() == UserModel.Role.admin) {
                response.sendRedirect("AdminDashboardServlet");
            } else {
                response.sendRedirect("UserDashboardServlet");
            }
            return;
        }

        // Check for "Remember Me" cookie to prefill the email field in login form
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("userEmail")) {
                    request.setAttribute("savedEmail", c.getValue());
                    break;
                }
            }
        }

        // Pass any success message (e.g., registration success) to the login page
        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("successMessage", message);
        }

        // Forward request to login JSP to render login form
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests to authenticate the user and manage session and cookies.
     *
     * @param request  HttpServletRequest object
     * @param response HttpServletResponse object
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieve email, password, and remember-me checkbox values from form submission
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String remember = request.getParameter("remember");

            // Validate email input
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Email is required");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // Validate password input
            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Password is required");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // Authenticate user credentials via AuthService
            UserModel user = AuthService.login(email, password);

            if (user != null) {
                // Login successful - create user session with timeout (30 minutes)
                AuthService.createUserSession(request, user, 1800);

                // Handle "Remember Me" cookie
                if ("on".equals(remember)) {
                    Cookie cookie = new Cookie("userEmail", email);
                    cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                    response.addCookie(cookie);
                } else {
                    // Clear cookie if "Remember Me" not selected
                    Cookie cookie = new Cookie("userEmail", "");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }

                // Optionally prepare profile image as base64 for frontend use
                if (user.getImage() != null && user.getImage().length > 0) {
                    String base64Image = Base64.getEncoder().encodeToString(user.getImage());
                    request.setAttribute("base64Image", base64Image);
                }

                // Redirect user to their respective dashboard
                if (user.getRole() == UserModel.Role.admin) {
                    response.sendRedirect("AdminDashboardServlet");
                } else {
                    response.sendRedirect("UserDashboardServlet");
                }
            } else {
                // Authentication failed - show error on login page
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Handle unexpected exceptions gracefully
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
