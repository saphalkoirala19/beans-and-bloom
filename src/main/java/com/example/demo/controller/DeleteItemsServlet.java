package com.example.demo.controller;

import com.example.demo.dao.ItemsDAO;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteItemServlet", value = "/DeleteItemServlet")
public class DeleteItemsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only allow admin users to delete items
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Retrieve item ID from request
            int id = Integer.parseInt(request.getParameter("id"));

            // Attempt to delete the item using DAO
            boolean deleted = ItemsDAO.deleteItem(id);

            // Set success or error message for the session
            if (deleted) {
                session.setAttribute("success", "Item deleted successfully");
            } else {
                session.setAttribute("error", "Failed to delete item");
            }

        } catch (Exception ex) {
            // Handle parsing or deletion errors gracefully
            session.setAttribute("error", "An error occurred: " + ex.getMessage());
        }

        // Redirect back to the item listing page
        response.sendRedirect("ListItemsServlet");
    }
}
