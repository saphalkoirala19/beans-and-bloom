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

@WebServlet(name = "CustomerItemsServlet", value = "/CustomerItemsServlet")
public class CustomerItemsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        if (!AuthService.isAuthenticated(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Retrieve filter parameters
            String nameFilter = request.getParameter("name");
            String statusFilter = request.getParameter("status");
            String categoryFilter = request.getParameter("category");

            // Store filter values for rendering back in the view
            request.setAttribute("currentNameFilter", nameFilter);
            request.setAttribute("currentStatusFilter", statusFilter);
            request.setAttribute("currentCategoryFilter", categoryFilter);

            // Get filtered items
            List<itemsModel> items = applyFilters(nameFilter, statusFilter, categoryFilter);

            // Prepare item data with image in Base64 for display
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

                // Convert image bytes to Base64 string
                if (item.getImage() != null && item.getImage().length > 0) {
                    String base64Image = Base64.getEncoder().encodeToString(item.getImage());
                    itemMap.put("image", base64Image);
                }

                itemList.add(itemMap);
            }

            request.setAttribute("items", itemList);
            request.getRequestDispatcher("/WEB-INF/views/customer-items.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Unable to load customer items.");
            response.sendRedirect("DashboardServlet");
        }
    }

    /**
     * Applies filtering logic to return items based on name, status, and category filters.
     */
    private List<itemsModel> applyFilters(String nameFilter, String statusFilter, String categoryFilter) {
        List<itemsModel> items = new ArrayList<>();

        // No filters applied
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            return ItemsDAO.getAllItems();
        }

        // Only name filter
        if (nameFilter != null && !nameFilter.isEmpty() &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            return ItemsDAO.searchItemsByName(nameFilter);
        }

        // Only status filter
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                statusFilter != null && !statusFilter.isEmpty() &&
                (categoryFilter == null || categoryFilter.isEmpty())) {
            Status status = Status.valueOf(statusFilter.toUpperCase());
            return ItemsDAO.getItemsByStatus(status);
        }

        // Only category filter
        if ((nameFilter == null || nameFilter.isEmpty()) &&
                (statusFilter == null || statusFilter.isEmpty()) &&
                categoryFilter != null && !categoryFilter.isEmpty()) {
            Category category = Category.valueOf(categoryFilter.toUpperCase());
            return ItemsDAO.getItemsByCategory(category);
        }

        // Combined filters (intersection of multiple criteria)
        List<itemsModel> filteredItems = ItemsDAO.getAllItems();

        // Apply name filter
        if (nameFilter != null && !nameFilter.isEmpty()) {
            List<itemsModel> nameFiltered = ItemsDAO.searchItemsByName(nameFilter);
            filteredItems = intersectLists(filteredItems, nameFiltered);
        }

        // Apply status filter
        if (statusFilter != null && !statusFilter.isEmpty()) {
            Status status = Status.valueOf(statusFilter.toUpperCase());
            List<itemsModel> statusFiltered = ItemsDAO.getItemsByStatus(status);
            filteredItems = intersectLists(filteredItems, statusFiltered);
        }

        // Apply category filter
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            Category category = Category.valueOf(categoryFilter.toUpperCase());
            List<itemsModel> categoryFiltered = ItemsDAO.getItemsByCategory(category);
            filteredItems = intersectLists(filteredItems, categoryFiltered);
        }

        return filteredItems;
    }

    /**
     * Returns the intersection of two item lists by comparing their IDs.
     */
    private List<itemsModel> intersectLists(List<itemsModel> list1, List<itemsModel> list2) {
        Set<Integer> ids = list2.stream()
                .map(itemsModel::getId)
                .collect(Collectors.toSet());

        return list1.stream()
                .filter(item -> ids.contains(item.getId()))
                .collect(Collectors.toList());
    }
}
