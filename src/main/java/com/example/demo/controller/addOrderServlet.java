package com.example.demo.controller;

import com.example.demo.dao.ItemsDAO;
import com.example.demo.dao.OrderItemsDAO;
import com.example.demo.dao.OrdersDAO;
import com.example.demo.models.OrderItemModel;
import com.example.demo.models.itemsModel;
import com.example.demo.models.OrderModel;
import com.example.demo.services.AuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Timestamp;

/**
 * AddOrderServlet
 *
 * Handles adding orders by customers.
 * Supports:
 * - GET with action=view to show order form for available items.
 * - GET with action=add to process adding an order with quantity.
 *
 * Only accessible by authenticated users.
 */
@WebServlet(name = "AddOrderServlet", value = "/AddOrderServlet")
public class addOrderServlet extends HttpServlet {

    private OrdersDAO ordersDao;
    private ItemsDAO itemsDao;
    private OrderItemsDAO orderItemsDao;

    @Override
    public void init() {
        ordersDao = new OrdersDAO();
        itemsDao = new ItemsDAO();
        orderItemsDao = new OrderItemsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        if (!AuthService.isUser(request)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        if ("view".equalsIgnoreCase(action)) {
            // Show the order form for a selected available item
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                itemsModel item = itemsDao.getItemById(itemId);

                if (item != null && "AVAILABLE".equals(item.getStatus().toString())) {
                    request.setAttribute("item", item);
                    request.getRequestDispatcher("/WEB-INF/views/add-order.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("error", "Item is not available.");
                    response.sendRedirect("CustomerItemsServlet");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid item ID.");
                response.sendRedirect("CustomerItemsServlet");
            }

        } else if ("add".equalsIgnoreCase(action)) {
            // Process adding an order and order item
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                itemsModel item = itemsDao.getItemById(itemId);

                if (item != null && "AVAILABLE".equals(item.getStatus().toString())) {

                    // Create new order object and set fields
                    OrderModel order = new OrderModel();
                    order.setUserId(AuthService.getUserId(request));
                    order.setStatus(OrderModel.Status.PENDING);
                    order.setQuantity(quantity);
                    order.setTotalAmount(item.getPrice() * quantity);
                    order.setOrderDate(new Timestamp(System.currentTimeMillis()));

                    // Insert order in DB and get generated order ID
                    int orderId = ordersDao.createOrder(order);

                    if (orderId > 0) {
                        // Create order item object
                        OrderItemModel orderItem = new OrderItemModel();
                        orderItem.setOrderId(orderId);
                        orderItem.setItemId(itemId);
                        orderItem.setName(item.getName());
                        orderItem.setPrice(item.getPrice());
                        orderItem.setQuantity(quantity);

                        // Insert order item in DB
                        boolean itemSaved = orderItemsDao.createOrderItem(orderItem);

                        if (itemSaved) {
                            request.getSession().setAttribute("success", "Order placed successfully!");
                        } else {
                            // Rollback order if order item save failed
                            ordersDao.deleteOrder(orderId);
                            request.getSession().setAttribute("error", "Failed to save order items.");
                        }
                    } else {
                        request.getSession().setAttribute("error", "Failed to place order.");
                    }
                } else {
                    request.getSession().setAttribute("error", "Item is not available.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid item ID or quantity.");
            }

            response.sendRedirect("CustomerItemsServlet");
        }
    }
}
