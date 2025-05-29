package com.example.demo.controller;

import com.example.demo.dao.OrdersDAO;
import com.example.demo.models.OrderModel;
import com.example.demo.models.OrderModel.Status;
import com.example.demo.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * CancelCustomerOrderServlet
 *
 * This servlet handles the cancellation of a customer's order.
 * Only logged-in users can cancel their own PENDING orders.
 */
@WebServlet(name = "CancelOrderServlet", value = "/cancel-order")
public class CancelCustomerOrderServlet extends HttpServlet {
    private OrdersDAO ordersDao;

    /**
     * Initializes the OrdersDAO instance used to interact with the order data.
     */
    @Override
    public void init() {
        ordersDao = new OrdersDAO();
    }

    /**
     * Handles POST request to cancel a customer order.
     * Ensures the user is authenticated, the order is theirs, and it's still pending.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure user is authenticated (not admin)
        if (!AuthService.isUser(request)) {
            response.sendRedirect("login");
            return;
        }

        // Parse orderId from request and get userId from session
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int userId = AuthService.getUserId(request);

        // Fetch order from database
        OrderModel order = ordersDao.getOrderById(orderId);

        // Validate that the order exists, belongs to the user, and is in PENDING state
        if (order == null || order.getUserId() != userId || order.getStatus() != Status.PENDING) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only cancel your own pending orders");
            return;
        }

        // Set order status to CANCELLED
        order.setStatus(Status.CANCELLED);

        // Persist the update to the database
        ordersDao.updateOrder(order);

        // Redirect back to the customer's order list
        response.sendRedirect(request.getContextPath() + "/customer-orders");
    }
}
