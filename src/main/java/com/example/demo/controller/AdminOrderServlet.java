package com.example.demo.controller;

import com.example.demo.dao.OrdersDAO;
import com.example.demo.models.OrderModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * AdminOrderServlet
 *
 * Handles viewing and updating of orders by the admin.
 * Only users with admin privileges (checked via AuthService) are allowed to access.
 */
@WebServlet("/admin-orders")
public class AdminOrderServlet extends HttpServlet {
    private OrdersDAO ordersDao;

    /**
     * Initialize the DAO instance
     */
    @Override
    public void init() {
        ordersDao = new OrdersDAO();
    }

    /**
     * Handles GET requests to display orders on admin page.
     * Admins can optionally filter by order status.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect to login if user is not an admin
        if (!AuthService.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Optional status filter from query parameter
            String statusFilter = request.getParameter("status");
            List<OrderModel> orders;

            if (statusFilter != null && !statusFilter.isEmpty()) {
                // Fetch filtered orders based on status
                orders = ordersDao.getOrdersByStatus(OrderModel.Status.valueOf(statusFilter));
            } else {
                // Fetch all orders if no filter provided
                orders = ordersDao.getAllOrders();
            }

            // Pass orders and status values to the JSP for display
            request.setAttribute("orders", orders);
            request.setAttribute("statusValues", OrderModel.Status.values());

            // Forward to admin orders JSP
            request.getRequestDispatcher("/WEB-INF/views/admin-orders.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle unexpected error by showing error.jsp with message
            request.setAttribute("error", "Error loading orders: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests to update order status by admin.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Return 403 Forbidden if user is not admin
        if (!AuthService.isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // Parse orderId and new status from request parameters
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            OrderModel.Status newStatus = OrderModel.Status.valueOf(request.getParameter("status"));

            // Fetch the existing order from the database
            OrderModel order = ordersDao.getOrderById(orderId);

            if (order == null) {
                // If order does not exist
                request.getSession().setAttribute("error", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin-orders");
                return;
            }

            // Check if the requested status change is valid
            if (!isValidStatusTransition(order.getStatus(), newStatus)) {
                request.getSession().setAttribute("error", "Invalid status transition");
                response.sendRedirect(request.getContextPath() + "/admin-orders");
                return;
            }

            // Attempt to update order status
            if (ordersDao.updateOrderStatus(orderId, newStatus)) {
                request.getSession().setAttribute("success", "Order status updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update order status");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid order ID");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Invalid status value");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        // Always redirect back to admin orders page
        response.sendRedirect(request.getContextPath() + "/admin-orders");
    }

    /**
     * Determines whether a status transition is valid based on business rules.
     */
    private boolean isValidStatusTransition(OrderModel.Status currentStatus, OrderModel.Status newStatus) {
        switch (currentStatus) {
            case PENDING:
                return newStatus == OrderModel.Status.ON_THE_WAY ||
                        newStatus == OrderModel.Status.CANCELLED;
            case ON_THE_WAY:
                return newStatus == OrderModel.Status.COMPLETED;
            case COMPLETED:
            case CANCELLED:
                return false; // Final states, no further transitions allowed
            default:
                return false;
        }
    }
}
