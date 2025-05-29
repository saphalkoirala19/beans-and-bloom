package com.example.demo.dao;

import com.example.demo.models.OrderModel;
import com.example.demo.models.OrderModel.Status;
import com.example.demo.utils.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// This class handles all database operations for orders
public class OrdersDAO {

    // SQL queries we'll use
    private static final String INSERT_ORDER = "INSERT INTO orders (user_id, status, total_amount, order_date, quantity) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_ORDER_BY_ID = "SELECT o.*, u.name as customer_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
    private static final String SELECT_ALL_ORDERS = "SELECT o.*, u.name as customer_name FROM orders o JOIN users u ON o.user_id = u.id";
    private static final String UPDATE_ORDER = "UPDATE orders SET user_id=?, status=?, quantity=?, total_amount=?, order_date=? WHERE id=?";
    private static final String DELETE_ORDER = "DELETE FROM orders WHERE id=?";
    private static final String SELECT_ORDERS_BY_USER = "SELECT o.*, u.name as customer_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.user_id = ?";
    private static final String SELECT_ORDERS_BY_STATUS = "SELECT o.*, u.name as customer_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.status = ?";

    // Create a new order in the database
    public static int createOrder(OrderModel order) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_ORDER, PreparedStatement.RETURN_GENERATED_KEYS)) {

            // Set values for the SQL query from the order object
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getStatus().name());
            ps.setDouble(3, order.getTotalAmount());
            ps.setTimestamp(4, order.getOrderDate());
            ps.setInt(5, order.getQuantity());

            int rows = ps.executeUpdate();

            // If successful, return the new order's ID
            if (rows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return -1; // Return -1 if failed
    }

    // Get a single order by its ID
    public static OrderModel getOrderById(int id) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ORDER_BY_ID)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            // If found, convert database result to OrderModel object
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving order by ID: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return null; // Return null if not found
    }

    // Get all orders from the database
    public static List<OrderModel> getAllOrders() {
        List<OrderModel> orders = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {

            // Convert each database row to OrderModel and add to list
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all orders: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return orders;
    }

    // Update an existing order
    public static boolean updateOrder(OrderModel order) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_ORDER)) {

            // Set values for the SQL query from the order object
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getStatus().name());
            ps.setInt(3, order.getQuantity());
            ps.setDouble(4, order.getTotalAmount());
            ps.setTimestamp(5, order.getOrderDate());
            ps.setInt(6, order.getId());

            // Return true if update was successful
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    // Delete an order by its ID
    public static boolean deleteOrder(int orderId) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_ORDER)) {

            ps.setInt(1, orderId);
            // Return true if deletion was successful
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting order: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    // Get all orders for a specific user
    public static List<OrderModel> getOrdersByUser(int userId) {
        List<OrderModel> orders = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ORDERS_BY_USER)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            // Convert each database row to OrderModel and add to list
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving orders by user: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return orders;
    }

    // Get all orders with a specific status
    public static List<OrderModel> getOrdersByStatus(Status status) {
        List<OrderModel> orders = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ORDERS_BY_STATUS)) {

            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();

            // Convert each database row to OrderModel and add to list
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving orders by status: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return orders;
    }

    // Helper method to convert database result to OrderModel object
    private static OrderModel mapResultSetToOrder(ResultSet rs) throws SQLException {
        OrderModel order = new OrderModel();
        // Set all fields from the database result
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setCustomerName(rs.getString("customer_name"));

        // Convert status string to enum value
        try {
            order.setStatus(Status.valueOf(rs.getString("status")));
        } catch (IllegalArgumentException e) {
            order.setStatus(Status.PENDING); // Default to PENDING if status is invalid
        }

        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setQuantity(rs.getInt("quantity"));
        return order;
    }

    // Update just the status of an order
    public static boolean updateOrderStatus(int orderId, Status status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            // Convert enum to string value
            String statusValue = status.name();

            // For debugging (can be removed later)
            System.out.println("Updating order " + orderId + " to status: " + statusValue);

            ps.setString(1, statusValue);
            ps.setInt(2, orderId);

            // Return true if update was successful
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("No rows affected - order ID " + orderId + " may not exist");
            }
            return rowsAffected > 0;

        } catch (SQLException e) {
            // Detailed error information
            System.err.println("SQL Error updating status for order " + orderId + ":");
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            throw new RuntimeException("Failed to update order status", e);
        }
    }
}