package com.example.demo.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * ContactUsServlet
 *
 * Handles the static "Contact Us" page display.
 */
@WebServlet(name = "ContactUsServlet", value = "/ContactUsServlet")
public class ContactUsServlet extends HttpServlet {

    /**
     * Handles GET requests and forwards to the contact-us.jsp page.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Forward to contact-us.jsp view
        req.getRequestDispatcher("/WEB-INF/views/contact-us.jsp").forward(req, resp);
    }

    /**
     * Handles POST requests by redirecting to GET (static content).
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Delegate POST to GET (since page is static)
        doGet(req, resp);
    }
}
