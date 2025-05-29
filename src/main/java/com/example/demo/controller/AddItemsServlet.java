package com.example.demo.controller;

import com.example.demo.dao.ItemsDAO;
import com.example.demo.models.itemsModel;
import com.example.demo.models.itemsModel.Category;
import com.example.demo.models.itemsModel.Status;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;

/**
 * AddItemsServlet
 *
 * Handles adding new items to the inventory.
 * Supports GET for displaying the add item form,
 * and POST for processing the form submission with validation.
 * Only accessible by admin users.
 */
@WebServlet(name = "AddItemServlet", value = "/AddItemServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold for file size before writing to disk
        maxFileSize = 1024 * 1024 * 10,       // Max file size 10MB
        maxRequestSize = 1024 * 1024 * 50     // Max request size 50MB
)
public class AddItemsServlet extends HttpServlet {

    /**
     * Handles GET request - displays the add item form.
     * Redirects to login if user is not an admin.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/add-items.jsp").forward(request, response);
    }

    /**
     * Handles POST request - processes the add item form submission.
     * Validates inputs, handles image upload with validation,
     * creates new item, and saves to database.
     * Provides success or error feedback via session attributes.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Retrieve form parameters
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Category category = Category.valueOf(request.getParameter("category"));
            Status status = Status.valueOf(request.getParameter("status"));

            // Handle image upload part
            Part filePart = request.getPart("itemImage");
            byte[] imageBytes = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Validate file type is image
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    session.setAttribute("error", "Only image files are allowed (JPEG, PNG, GIF)");
                    response.sendRedirect("AddItemServlet");
                    return;
                }

                // Validate file size (max 5MB)
                if (filePart.getSize() > 5 * 1024 * 1024) {
                    session.setAttribute("error", "Image size must be less than 5MB");
                    response.sendRedirect("AddItemServlet");
                    return;
                }

                // Read image bytes
                try (InputStream fileContent = filePart.getInputStream()) {
                    imageBytes = fileContent.readAllBytes();
                }
            }

            // Construct new item model and set fields
            itemsModel newItem = new itemsModel();
            newItem.setName(name);
            newItem.setDescription(description);
            newItem.setPrice(price);
            newItem.setQuantity(quantity);
            newItem.setCategory(category);
            newItem.setStatus(status);
            newItem.setImage(imageBytes);

            // Save item to database using DAO
            int itemId = ItemsDAO.createItem(newItem);

            if (itemId > 0) {
                session.setAttribute("success", "Item added successfully");
                response.sendRedirect("ListItemsServlet");
            } else {
                session.setAttribute("error", "Failed to add item. Please try again.");
                response.sendRedirect("AddItemServlet");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid number format for price or quantity");
            response.sendRedirect("AddItemServlet");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", "Invalid category or status selected");
            response.sendRedirect("AddItemServlet");
        } catch (Exception ex) {
            session.setAttribute("error", "An error occurred: " + ex.getMessage());
            response.sendRedirect("AddItemServlet");
        }
    }
}
