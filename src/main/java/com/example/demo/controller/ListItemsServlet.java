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
import java.util.*;
import java.util.stream.Collectors;
import java.util.Base64;

@WebServlet(name = "ListItemsServlet", value = "/ListItemsServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1MB threshold before writing to disk
        maxFileSize = 1024 * 1024 * 5,      // Max file size per upload: 5MB
        maxRequestSize = 1024 * 1024 * 10   // Max total request size: 10MB
)
public class ListItemsServlet extends HttpServlet {

    /**
     * Handles GET requests to display list of items.
     * Applies filters based on request parameters (name, status, category),
     * converts images to Base64 for display,
     * and forwards to the JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to login if user not authenticated
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Retrieve filter parameters from request
            String nameFilter = request.getParameter("name");
            String statusFilter = request.getParameter("status");
            String categoryFilter = request.getParameter("category");

            // Save current filter values as request attributes for form repopulation
            request.setAttribute("currentNameFilter", nameFilter);
            request.setAttribute("currentStatusFilter", statusFilter);
            request.setAttribute("currentCategoryFilter", categoryFilter);

            // Get the filtered list of items using helper method
            List<itemsModel> items = applyFilters(nameFilter, statusFilter, categoryFilter);

            // Prepare a list of maps to hold item data with Base64-encoded images
            List<Map<String, Object>> itemList = new ArrayList<>();

            for (itemsModel item : items) {
                Map<String, Object> itemMap = new HashMap<>();
                itemMap.put("id", item.getId());
                itemMap.put("name", item.getName());
                itemMap.put("description", item.getDescription());
                itemMap.put("price", item.getPrice());
                itemMap.put("quantity", item.getQuantity());
                itemMap.put("category", item.getCategory());
                itemMap.put("status", item.getStatus());

                // Convert binary image data to Base64 string for embedding in HTML
                if (item.getImage() != null && item.getImage().length > 0) {
                    String base64Image = Base64.getEncoder().encodeToString(item.getImage());
                    itemMap.put("image", base64Image); // Key for image data in JSP
                }

                itemList.add(itemMap);
            }

            // Add the processed item list as a request attribute
            request.setAttribute("items", itemList);

            // Forward to JSP page that displays the items
            request.getRequestDispatcher("/WEB-INF/views/list-items.jsp").forward(request, response);

        } catch (Exception ex) {
            // On error, set error message in session and redirect to dashboard
            session.setAttribute("error", "Error loading items: " + ex.getMessage());
            response.sendRedirect("DashboardServlet");
        }
    }

    /**
     * Applies filters to the items list based on provided filter parameters.
     * Uses DAO methods to get items by name, status, category, or combinations.
     * @param nameFilter - filter by item name (partial match)
     * @param statusFilter - filter by item status (exact match)
     * @param categoryFilter - filter by item category (exact match)
     * @return filtered list of items
     */
    private List<itemsModel> applyFilters(String nameFilter, String statusFilter, String categoryFilter) {
        // Initialize items list
        List<itemsModel> items = new ArrayList<>();

        // Case 1: No filters - return all items
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            return ItemsDAO.getAllItems();
        }

        // Case 2: Only name filter applied
        if (nameFilter != null && !nameFilter.isEmpty() &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            return ItemsDAO.searchItemsByName(nameFilter);
        }

        // Case 3: Only status filter applied
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                statusFilter != null && !statusFilter.isEmpty() &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            Status status = Status.valueOf(statusFilter.toUpperCase());
            return ItemsDAO.getItemsByStatus(status);
        }

        // Case 4: Only category filter applied
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                categoryFilter != null && !categoryFilter.isEmpty()) {
            Category category = Category.valueOf(categoryFilter.toUpperCase());
            return ItemsDAO.getItemsByCategory(category);
        }

        // Case 5: Multiple filters combined
        List<itemsModel> filteredItems = ItemsDAO.getAllItems();

        // Filter by name if present
        if (nameFilter != null && !nameFilter.isEmpty()) {
            List<itemsModel> nameFiltered = ItemsDAO.searchItemsByName(nameFilter);
            filteredItems = intersectLists(filteredItems, nameFiltered);
        }

        // Filter by status if present
        if (statusFilter != null && !statusFilter.isEmpty()) {
            Status status = Status.valueOf(statusFilter.toUpperCase());
            List<itemsModel> statusFiltered = ItemsDAO.getItemsByStatus(status);
            filteredItems = intersectLists(filteredItems, statusFiltered);
        }

        // Filter by category if present
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            Category category = Category.valueOf(categoryFilter.toUpperCase());
            List<itemsModel> categoryFiltered = ItemsDAO.getItemsByCategory(category);
            filteredItems = intersectLists(filteredItems, categoryFiltered);
        }

        return filteredItems;
    }

    /**
     * Helper method to find the intersection between two lists of items based on their IDs.
     * Returns items that are present in both lists.
     * @param list1 first list of items
     * @param list2 second list of items
     * @return intersection list
     */
    private List<itemsModel> intersectLists(List<itemsModel> list1, List<itemsModel> list2) {
        // Collect IDs of the second list for fast lookup
        Set<Integer> ids = list2.stream()
                .map(itemsModel::getId)
                .collect(Collectors.toSet());

        // Filter the first list to items that exist in the second list
        return list1.stream()
                .filter(item -> ids.contains(item.getId()))
                .collect(Collectors.toList());
    }
}
