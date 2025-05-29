package com.example.demo.controller;

import com.example.demo.models.UserModel;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", value = "/DashboardServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,       // 1MB threshold for in-memory vs disk
        maxFileSize = 1024 * 1024 * 5,         // Max 5MB per file
        maxRequestSize = 1024 * 1024 * 10      // Max 10MB total for the request
)
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve current session and user object
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("user");

        // Redirect to login if user is not authenticated
        if (user == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Set user data to be used in JSP
        request.setAttribute("user", user);

        // Forward the request to list-items.jsp view (user dashboard)
        request.getRequestDispatcher("/WEB-INF/views/list-items.jsp").forward(request, response);
    }
}
