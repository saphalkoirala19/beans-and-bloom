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
import java.util.Base64;

@WebServlet(name = "EditItemServlet", value = "/EditItemServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB threshold before writing to disk
        maxFileSize = 1024 * 1024 * 5,   // Max file size per upload: 5MB
        maxRequestSize = 1024 * 1024 * 10 // Max total request size: 10MB
)
public class EditItemsServlet extends HttpServlet {

    /**
     * Handles GET request to display the edit form for a specific item.
     * Verifies admin authentication, retrieves item by ID,
     * and converts its image to Base64 string for displaying in the form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if current user is admin; redirect to login if not
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            // Parse item ID from request parameter
            int id = Integer.parseInt(request.getParameter("id"));

            // Retrieve item details from DB
            itemsModel item = ItemsDAO.getItemById(id);

            // If item does not exist, return 404
            if (item == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Set item data for JSP display
            request.setAttribute("item", item);

            // Convert item image bytes to Base64 string if image exists
            if (item.getImage() != null && item.getImage().length > 0) {
                String base64Image = Base64.getEncoder().encodeToString(item.getImage());
                request.setAttribute("base64Image", base64Image);
            }

            // Forward to JSP page for editing item
            request.getRequestDispatcher("/WEB-INF/views/edit-items.jsp").forward(request, response);

        } catch (Exception ex) {
            // Wrap and rethrow exception as ServletException for container handling
            throw new ServletException(ex);
        }
    }

    /**
     * Handles POST request to update an item.
     * Validates admin authentication, processes form data including optional image upload,
     * updates the item in the database, and redirects accordingly.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verify admin access; redirect to login if not authorized
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Parse item ID and fetch existing item record
            int id = Integer.parseInt(request.getParameter("id"));
            itemsModel existingItem = ItemsDAO.getItemById(id);

            // If item not found, send 404 response
            if (existingItem == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Retrieve form parameters
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Category category = Category.valueOf(request.getParameter("category"));
            Status status = Status.valueOf(request.getParameter("status"));

            // Handle image upload part; read bytes if a new image is provided
            Part filePart = request.getPart("itemImage");
            byte[] imageBytes = null;
            if (filePart != null && filePart.getSize() > 0) {
                imageBytes = filePart.getInputStream().readAllBytes();
            }

            // Create updated item model with new data
            itemsModel updatedItem = new itemsModel();
            updatedItem.setId(id);
            updatedItem.setName(name);
            updatedItem.setDescription(description);
            updatedItem.setPrice(price);
            updatedItem.setQuantity(quantity);
            updatedItem.setCategory(category);
            updatedItem.setStatus(status);
            // Use new image if uploaded; otherwise keep existing image
            updatedItem.setImage(imageBytes != null ? imageBytes : existingItem.getImage());

            // Persist the updated item in the database
            boolean updated = ItemsDAO.updateItem(updatedItem, imageBytes != null);

            if (updated) {
                // Set success message and redirect to items list
                session.setAttribute("success", "Item updated successfully");
                response.sendRedirect("ListItemsServlet");
            } else {
                // Set error message and redirect back to edit form
                session.setAttribute("error", "Failed to update item");
                response.sendRedirect("EditItemServlet?id=" + id);
            }
        } catch (Exception ex) {
            // Handle exceptions, set error message and redirect to items list
            session.setAttribute("error", "An error occurred: " + ex.getMessage());
            response.sendRedirect("ListItemsServlet");
        }
    }
}
