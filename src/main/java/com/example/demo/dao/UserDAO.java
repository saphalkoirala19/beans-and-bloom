package com.example.demo.dao;

import com.example.demo.models.UserModel;
import com.example.demo.utils.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// This class handles all database operations for users
public class UserDAO {

    // Different SQL queries for different update scenarios
    public static final String UPDATE_USER_WITH_PASSWORD = "UPDATE users SET name=?, email=?, role=?, profile_picture=?, password=? WHERE id=?";
    public static final String UPDATE_USER_WITHOUT_PASSWORD = "UPDATE users SET name=?, email=?, role=?, profile_picture=? WHERE id=?";
    public static final String UPDATE_USER_WITHOUT_IMAGE = "UPDATE users SET name=?, email=?, role=? WHERE id=?";
    public static final String UPDATE_USER_WITH_PASSWORD_NO_IMAGE = "UPDATE users SET name=?, email=?, role=?, password=? WHERE id=?";

    // Basic user update query
    public static final String UPDATE_USER = "UPDATE users SET name=?, email=?, role=?, profile_picture=? WHERE id=?";

    // Query to delete a user
    public static final String DELETE_USER = "DELETE FROM users WHERE id=?";

    // Query to get all users
    public static final String SELECT_ALL_USERS = "SELECT * FROM users";

    // Query to add a new user
    public static final String INSERT_USER = "INSERT INTO users(name, email, password, role, profile_picture) VALUES (?,?,?,?, ?)";

    // Query to find user by email (for login)
    public static final String SELECT_USER_BY_EMAIL = "SELECT * FROM users WHERE email = ?";

    // Query to find user by ID
    public static final String SELECT_USER_BY_ID = "SELECT * FROM users WHERE id = ?";

    // Register a new user in the database
    public static int registerUser(UserModel user) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_USER, PreparedStatement.RETURN_GENERATED_KEYS);) {

            // Set all user data for the insert query
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Note: Password should be hashed in production
            ps.setString(4, user.getRole().name());
            ps.setBytes(5, user.getImage());

            // Execute the insert
            int rows = ps.executeUpdate();

            // If successful, return the new user's ID
            if (rows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return -1; // Return -1 if failed
    }

    // Old login method (marked as deprecated - not recommended for use)
    @Deprecated
    public static UserModel loginUser(UserModel user) {
        // This method is outdated - now we get user by email and verify password separately
        return getUserByEmail(user.getEmail());
    }

    // Get a user by their email address
    public static UserModel getUserByEmail(String email) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USER_BY_EMAIL);) {

            ps.setString(1, email); // Set the email to search for
            ResultSet rs = ps.executeQuery();

            // If found, create and return UserModel object
            if (rs.next()) {
                UserModel userFromDB = new UserModel();
                userFromDB.setId(rs.getInt("id"));
                userFromDB.setName(rs.getString("name"));
                userFromDB.setEmail(rs.getString("email"));
                userFromDB.setPassword(rs.getString("password"));
                userFromDB.setRole(UserModel.Role.valueOf(rs.getString("role")));
                userFromDB.setImage(rs.getBytes("profile_picture"));
                return userFromDB;
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user by email: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return null; // Return null if not found
    }

    // Get a user by their ID
    public static UserModel getUserById(int id) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USER_BY_ID);) {

            ps.setInt(1, id); // Set the ID to search for
            ResultSet rs = ps.executeQuery();

            // If found, create and return UserModel object
            if (rs.next()) {
                UserModel userFromDB = new UserModel();
                userFromDB.setId(rs.getInt("id"));
                userFromDB.setName(rs.getString("name"));
                userFromDB.setEmail(rs.getString("email"));
                userFromDB.setPassword(rs.getString("password"));
                userFromDB.setRole(UserModel.Role.valueOf(rs.getString("role")));
                userFromDB.setImage(rs.getBytes("profile_picture"));
                return userFromDB;
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user by ID: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return null; // Return null if not found
    }

    // Get all users from the database
    public static List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = ps.executeQuery()) {

            // For each user in the database, create UserModel and add to list
            while (rs.next()) {
                UserModel user = new UserModel();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(UserModel.Role.valueOf(rs.getString("role")));
                user.setImage(rs.getBytes("profile_picture"));
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all users: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return users;
    }

    // Update basic user information
    public static boolean updateUser(UserModel user, boolean changingPassword) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_USER)) {

            // Set all user data for the update query
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole().name());
            ps.setBytes(4, user.getImage());
            ps.setInt(5, user.getId());

            // Return true if update was successful
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    // Delete a user from the database
    public static boolean deleteUser(int userId) {
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_USER)) {

            ps.setInt(1, userId); // Set the ID of user to delete
            // Return true if deletion was successful
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    // Update user profile with different options
    public static boolean updateProfile(UserModel user, boolean updatePassword) {
        try (Connection connection = DBConnectionUtil.getConnection()) {
            String sql;

            // Choose the right SQL query based on what's being updated
            if (user.getImage() != null && user.getImage().length > 0) {
                sql = updatePassword ? UPDATE_USER_WITH_PASSWORD : UPDATE_USER_WITHOUT_PASSWORD;
            } else {
                sql = updatePassword ? UPDATE_USER_WITH_PASSWORD_NO_IMAGE : UPDATE_USER_WITHOUT_IMAGE;
            }

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                // Set common parameters
                ps.setString(1, user.getName());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getRole().name());

                int paramIndex = 4;
                // Add image data if present
                if (user.getImage() != null && user.getImage().length > 0) {
                    ps.setBytes(paramIndex++, user.getImage());
                }
                // Add password if being updated
                if (updatePassword) {
                    ps.setString(paramIndex++, user.getPassword());
                }

                // Set user ID
                ps.setInt(paramIndex, user.getId());

                // Return true if update was successful
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}