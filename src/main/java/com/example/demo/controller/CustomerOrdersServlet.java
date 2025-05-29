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

@WebServlet(name = "customer-orders", value = "/customer-orders")
public class CustomerOrdersServlet extends HttpServlet {
    private OrdersDAO ordersDao;

    @Override
    public void init() {
        // Initialize the OrdersDAO object
        ordersDao = new OrdersDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if a user is logged in and has the correct role
        if (!AuthService.isUser(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Get the user ID from the session/auth context
        int userId = AuthService.getUserId(request);

        // Fetch all orders placed by the current user
        List<OrderModel> orders = ordersDao.getOrdersByUser(userId);

        // Pass the order list to the JSP view
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/customer-orders.jsp").forward(request, response);
    }
}
