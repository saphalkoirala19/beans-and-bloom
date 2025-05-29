package com.example.demo.dao;

import com.example.demo.models.OrderItemModel;
import com.example.demo.utils.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for managing order items in the database.
 */
public class OrderItemsDAO {

    // SQL Queries
    private static final String INSERT_ITEM = "INSERT INTO order_items (order_id, item_id, item_name, item_price, quantity) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_BY_ORDER = "SELECT * FROM order_items WHERE order_id = ?";
    private static final String SELECT_BY_ID = "SELECT * FROM order_items WHERE id = ?";
    private static final String UPDATE_ITEM = "UPDATE order_items SET quantity = ? WHERE id = ?";
    private static final String DELETE_ITEM = "DELETE FROM order_items WHERE id = ?";
    private static final String DELETE_BY_ORDER = "DELETE FROM order_items WHERE order_id = ?";

    /**
     * Inserts a new order item into the database.
     *
     * @param item the order item to insert
     * @return true if insert was successful, false otherwise
     */
    public static boolean createOrderItem(OrderItemModel item) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_ITEM)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getItemId());
            ps.setString(3, item.getName());
            ps.setDouble(4, item.getPrice());
            ps.setInt(5, item.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating order item: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Retrieves all order items associated with a given order ID.
     *
     * @param orderId the ID of the order
     * @return a list of order items
     */
    public static List<OrderItemModel> getItemsByOrder(int orderId) {
        List<OrderItemModel> items = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_BY_ORDER)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToOrderItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving order items: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return items;
    }

    /**
     * Retrieves a single order item by its ID.
     *
     * @param id the ID of the order item
     * @return the corresponding OrderItemModel, or null if not found
     */
    public static OrderItemModel getOrderItemById(int id) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToOrderItem(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving order item: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return null;
    }

    /**
     * Updates the quantity of an existing order item.
     *
     * @param item the order item with updated quantity
     * @return true if update was successful, false otherwise
     */
    public static boolean updateOrderItem(OrderItemModel item) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_ITEM)) {

            ps.setInt(1, item.getQuantity());
            ps.setInt(2, item.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order item: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Deletes a single order item by its ID.
     *
     * @param id the ID of the order item to delete
     * @return true if deletion was successful, false otherwise
     */
    public static boolean deleteOrderItem(int id) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_ITEM)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting order item: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Deletes all order items associated with a given order ID.
     *
     * @param orderId the ID of the order
     * @return true if deletion was successful, false otherwise
     */
    public static boolean deleteItemsByOrder(int orderId) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_BY_ORDER)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting order items: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Helper method to convert a ResultSet row to an OrderItemModel.
     *
     * @param rs the ResultSet from a query
     * @return an OrderItemModel populated from the ResultSet
     * @throws SQLException if a database access error occurs
     */
    private static OrderItemModel mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItemModel item = new OrderItemModel();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setItemId(rs.getInt("item_id"));
        item.setName(rs.getString("item_name"));
        item.setPrice(rs.getDouble("item_price"));
        item.setQuantity(rs.getInt("quantity"));
        return item;
    }
}
