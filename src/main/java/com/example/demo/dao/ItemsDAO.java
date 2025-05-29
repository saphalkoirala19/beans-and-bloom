package com.example.demo.dao;

import com.example.demo.models.itemsModel;
import com.example.demo.models.itemsModel.Category;
import com.example.demo.models.itemsModel.Status;
import com.example.demo.utils.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class handles all database operations related to items.
 * It includes methods to create, read, update, delete, and search items.
 */
public class ItemsDAO {

    // SQL queries used in the methods
    private static final String INSERT_ITEM = "INSERT INTO items (name, description, price, quantity, category, status, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ITEM_BY_ID = "SELECT * FROM items WHERE id = ?";
    private static final String SELECT_ALL_ITEMS = "SELECT * FROM items";
    private static final String UPDATE_ITEM_WITH_IMAGE = "UPDATE items SET name=?, description=?, price=?, quantity=?, category=?, status=?, image=? WHERE id=?";
    private static final String UPDATE_ITEM_WITHOUT_IMAGE = "UPDATE items SET name=?, description=?, price=?, quantity=?, category=?, status=? WHERE id=?";
    private static final String DELETE_ITEM = "DELETE FROM items WHERE id=?";
    private static final String SELECT_ITEMS_BY_CATEGORY = "SELECT * FROM items WHERE category = ?";
    private static final String SELECT_ITEMS_BY_STATUS = "SELECT * FROM items WHERE status = ?";
    private static final String SELECT_ITEMS_BY_NAME = "SELECT * FROM items WHERE name LIKE ?";

    /**
     * Adds a new item to the database.
     * @param item the item to create
     * @return the generated ID of the item, or -1 if failed
     */
    public static int createItem(itemsModel item) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_ITEM, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setInt(4, item.getQuantity());
            ps.setString(5, item.getCategory().name());
            ps.setString(6, item.getStatus().name());
            ps.setBytes(7, item.getImage());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating item: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return -1;
    }

    /**
     * Finds an item by its ID.
     * @param id the item ID
     * @return the item object or null if not found
     */
    public static itemsModel getItemById(int id) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ITEM_BY_ID)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToItem(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving item by ID: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return null;
    }

    /**
     * Retrieves all items from the database.
     * @return a list of all items
     */
    public static List<itemsModel> getAllItems() {
        List<itemsModel> items = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_ITEMS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all items: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return items;
    }

    /**
     * Updates an existing item. Can optionally update the image.
     * @param item the item object with new data
     * @param updateImage whether to update the image or not
     * @return true if the update was successful
     */
    public static boolean updateItem(itemsModel item, boolean updateImage) {
        String sql = updateImage ? UPDATE_ITEM_WITH_IMAGE : UPDATE_ITEM_WITHOUT_IMAGE;

        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setInt(4, item.getQuantity());
            ps.setString(5, item.getCategory().name());
            ps.setString(6, item.getStatus().name());

            if (updateImage) {
                ps.setBytes(7, item.getImage());
                ps.setInt(8, item.getId());
            } else {
                ps.setInt(7, item.getId());
            }

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating item: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Deletes an item by its ID.
     * @param itemId the ID of the item to delete
     * @return true if deleted successfully
     */
    public static boolean deleteItem(int itemId) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_ITEM)) {

            ps.setInt(1, itemId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting item: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    /**
     * Gets a list of items filtered by category.
     * @param category the category to filter by
     * @return list of items in that category
     */
    public static List<itemsModel> getItemsByCategory(Category category) {
        List<itemsModel> items = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ITEMS_BY_CATEGORY)) {

            ps.setString(1, category.name());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving items by category: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return items;
    }

    /**
     * Gets a list of items filtered by status (e.g., AVAILABLE).
     * @param status the item status to filter by
     * @return list of items with that status
     */
    public static List<itemsModel> getItemsByStatus(Status status) {
        List<itemsModel> items = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ITEMS_BY_STATUS)) {

            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving items by status: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return items;
    }

    /**
     * Searches items whose name matches (or contains) the given text.
     * @param name the text to search
     * @return list of matching items
     */
    public static List<itemsModel> searchItemsByName(String name) {
        List<itemsModel> items = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ITEMS_BY_NAME)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error searching items by name: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return items;
    }

    /**
     * Helper method to convert a ResultSet row to an itemsModel object.
     */
    private static itemsModel mapResultSetToItem(ResultSet rs) throws SQLException {
        itemsModel item = new itemsModel();
        item.setId(rs.getInt("id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setQuantity(rs.getInt("quantity"));

        // Handle category safely
        try {
            item.setCategory(Category.valueOf(rs.getString("category")));
        } catch (IllegalArgumentException e) {
            item.setCategory(Category.OTHER); // Default if not valid
        }

        // Handle status safely
        try {
            item.setStatus(Status.valueOf(rs.getString("status")));
        } catch (IllegalArgumentException e) {
            item.setStatus(Status.AVAILABLE); // Default if not valid
        }

        item.setImage(rs.getBytes("image"));
        return item;
    }
}
