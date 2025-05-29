package com.example.demo.controller;

import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * LogoutServlet
 *
 * Handles user logout by ending the session.
 * After logout, redirects user to the login page with a message.
 */
@WebServlet(name = "LogoutServlet", value = "/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    /**
     * Handles GET requests for logout.
     * Checks if user was logged in, ends the session,
     * and redirects to login page with a logout success message.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        boolean wasLoggedIn = (session != null && session.getAttribute("user") != null);

        // Logout using AuthService (invalidate session)
        AuthService.logout(request);

        // Redirect to login page with success message if logged out
        if (wasLoggedIn) {
            response.sendRedirect("LoginServlet?message=You+have+been+successfully+logged+out");
        } else {
            // If no session existed, just redirect to login page
            response.sendRedirect("LoginServlet");
        }
    }

    /**
     * Handles POST requests by calling doGet method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
