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
 * Handles showing order details to the user or admin.
 *
 * Checks if user is logged in.
 * Validates order ID and checks if the user has permission to view the order.
 * Loads order and its items.
 * Redirects to order list if anything is wrong.
 */
@WebServlet(name = "ViewOrderServlet", value = "/view-order")
public class ViewOrderServlet extends HttpServlet {
    private OrdersDAO ordersDao;
    private OrderItemsDAO orderItemsDao;

    @Override
    public void init() {
        ordersDao = new OrdersDAO();
        orderItemsDao = new OrderItemsDAO();
    }

    /**
     * Loads and shows order details if the user is allowed to see it.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect to login if not logged in
        if (!AuthService.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get order ID from request, check if valid
            String orderIdParam = request.getParameter("id");
            if (orderIdParam == null || !orderIdParam.matches("\\d+")) {
                redirectToOrderList(request, response);
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);

            // Find the order by ID
            OrderModel order = ordersDao.getOrderById(orderId);

            // If order doesn't exist, redirect with error
            if (order == null) {
                redirectToOrderList(request, response, "Order not found");
                return;
            }

            // Check if user is allowed to see this order
            if (!hasAccessToOrder(request, order)) {
                redirectToOrderList(request, response, "Access denied");
                return;
            }

            // Load items for the order
            List<OrderItemModel> items = orderItemsDao.getItemsByOrder(orderId);

            // Pass data to JSP and show order details
            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.setAttribute("isAdmin", AuthService.isAdmin(request));
            request.getRequestDispatcher("/WEB-INF/views/orders/view.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            // If error, redirect to order list with message
            redirectToOrderList(request, response, "Error loading order details");
        }
    }

    // Check if current user is admin or owner of the order
    private boolean hasAccessToOrder(HttpServletRequest request, OrderModel order) {
        return AuthService.isAdmin(request) || order.getUserId() == AuthService.getUserId(request);
    }

    // Redirects to the order list page with optional error message
    private void redirectToOrderList(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String errorMessage) throws IOException {
        if (errorMessage != null) {
            request.getSession().setAttribute("error", errorMessage);
        }

        String redirectPath = AuthService.isAdmin(request)
                ? request.getContextPath() + "/admin-orders"
                : request.getContextPath() + "/customer-orders";

        response.sendRedirect(redirectPath);
    }

    // Redirect without error message
    private void redirectToOrderList(HttpServletRequest request,
                                     HttpServletResponse response) throws IOException {
        redirectToOrderList(request, response, null);
    }
}
