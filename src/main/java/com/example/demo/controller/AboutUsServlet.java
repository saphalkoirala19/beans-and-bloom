package com.example.demo.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * AboutUsServlet
 *
 * This servlet handles GET and POST requests to show the About Us page.
 * It forwards the request to the JSP located at /WEB-INF/views/about-us.jsp.
 */
@WebServlet(name = "AboutUsServlet", value = "/AboutUsServlet")
public class AboutUsServlet extends HttpServlet {

    /**
     * Handles GET requests by forwarding to the About Us JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/about-us.jsp").forward(req, resp);
    }

    /**
     * Handles POST requests by delegating to doGet,
     * so POST behaves the same as GET for this servlet.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        doGet(req, resp);
    }
}
