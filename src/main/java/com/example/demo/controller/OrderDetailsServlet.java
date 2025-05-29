package com.example.demo.controller;

import com.example.demo.dao.OrderItemsDAO;
import com.example.demo.dao.OrdersDAO;
import com.example.demo.models.OrderItemModel;
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
 * OrderDetailsServlet
 *
 * Handles displaying the details of a specific order.
 * Checks if user is authenticated and owns the order.
 * Fetches order and its items and forwards to order-details JSP.
 */
@WebServlet(name = "OrderDetailsServlet", value = "/order-details")
public class OrderDetailsServlet extends HttpServlet {
    private OrdersDAO ordersDao;
    private OrderItemsDAO orderItemsDao;

    /**
     * Initializes DAO instances.
     */
    @Override
    public void init() {
        ordersDao = new OrdersDAO();
        orderItemsDao = new OrderItemsDAO();
    }

    /**
     * Handles GET requests.
     * Verifies user authentication and order ownership.
     * Loads order and items, forwards to JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        if (!AuthService.isUser(request)) {
            response.sendRedirect("login");
            return;
        }

        // Get order ID from request parameter
        int orderId = Integer.parseInt(request.getParameter("id"));
        int userId = AuthService.getUserId(request);

        // Fetch order by ID
        OrderModel order = ordersDao.getOrderById(orderId);

        // Check if order exists and belongs to current user
        if (order == null || order.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only view your own orders");
            return;
        }

        // Fetch order items
        List<OrderItemModel> items = orderItemsDao.getItemsByOrder(orderId);

        // Set attributes and forward to JSP
        request.setAttribute("order", order);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/WEB-INF/views/order-details.jsp").forward(request, response);
    }
}
