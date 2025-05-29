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

@WebServlet("/delete-order")
public class DeleteOrderServlet extends HttpServlet {
    private OrdersDAO ordersDao;

    /**
     * Initializes the servlet and sets up the OrdersDAO instance.
     * Called once when the servlet is first loaded.
     */
    @Override
    public void init() {
        ordersDao = new OrdersDAO();
    }

    /**
     * Handles HTTP POST requests for deleting an order.
     * Only admins are authorized to perform this action.
     * Validates order existence and status before deletion.
     * Redirects back to the admin orders page with success or error messages.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if the requester is an admin; if not, send 403 Forbidden
        if (!AuthService.isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // Parse order ID from request parameter
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            // Fetch the order by ID
            OrderModel order = ordersDao.getOrderById(orderId);

            // If order not found, set error message and redirect
            if (order == null) {
                request.getSession().setAttribute("error", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin-orders");
                return;
            }

            // Allow deletion only if order is COMPLETED or CANCELLED
            if (order.getStatus() != OrderModel.Status.COMPLETED &&
                    order.getStatus() != OrderModel.Status.CANCELLED) {
                request.getSession().setAttribute("error", "Only completed or cancelled orders can be deleted");
                response.sendRedirect(request.getContextPath() + "/admin-orders");
                return;
            }

            // Attempt to delete the order, set success or failure message accordingly
            if (ordersDao.deleteOrder(orderId)) {
                request.getSession().setAttribute("success", "Order deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete order");
            }

        } catch (NumberFormatException e) {
            // Handle invalid orderId format in request parameter
            request.getSession().setAttribute("error", "Invalid order ID");
        } catch (Exception e) {
            // Catch-all for unexpected errors during processing
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        // Redirect back to admin orders page after processing
        response.sendRedirect(request.getContextPath() + "/admin-orders");
    }
}
