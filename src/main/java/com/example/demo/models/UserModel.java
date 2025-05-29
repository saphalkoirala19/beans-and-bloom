package com.example.demo.models;

import org.mindrot.jbcrypt.BCrypt;

import java.io.Serializable;

/**
 * The UserModel class represents a user of the application.
 * It includes fields for user credentials, role, and profile image.
 * It also uses BCrypt to securely hash and verify passwords.
 */
public class UserModel implements Serializable {

    /**
     * Enum representing the role of a user.
     * Can be either 'admin' or 'user'.
     */
    public enum Role {
        admin,
        user
    }

    // Unique identifier for the user
    private int id;

    // Full name of the user
    private String name;

    // Email address used for login
    private String email;

    // Hashed password stored securely
    private String password;

    // Role of the user (admin/user)
    private Role role;

    // Optional: profile picture of the user
    private byte[] image;

    /**
     * Default constructor.
     */
    public UserModel() {
    }

    // Getters and Setters

    /**
     * Returns the user ID.
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the user ID.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Returns the user's full name.
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the user's full name.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the user's email address.
     */
    public String getEmail() {
        return email;
    }

    /**
     * Sets the user's email address.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Returns the hashed password.
     */
    public String getPassword() {
        return password;
    }

    /**
     * Sets the password. Automatically hashes it using BCrypt if it is not already hashed.
     * @param password The plain text or hashed password.
     */
    public void setPassword(String password) {
        if (password != null && !password.startsWith("$2a$")) {
            // Hash the password if it is not already hashed
            this.password = BCrypt.hashpw(password, BCrypt.gensalt(12));
        } else {
            // Use as-is if already hashed
            this.password = password;
        }
    }

    /**
     * Returns the role of the user.
     */
    public Role getRole() {
        return role;
    }

    /**
     * Sets the role of the user.
     */
    public void setRole(Role role) {
        this.role = role;
    }

    /**
     * Returns the user's profile image (as byte array).
     */
    public byte[] getImage() {
        return image;
    }

    /**
     * Sets the user's profile image.
     */
    public void setImage(byte[] image) {
        this.image = image;
    }

    /**
     * Verifies a plaintext password against the stored hashed password.
     * @param plainTextPassword The plaintext password to verify.
     * @return True if the password matches, false otherwise.
     */
    public boolean verifyPassword(String plainTextPassword) {
        if (this.password == null || plainTextPassword == null) {
            return false;
        }
        return BCrypt.checkpw(plainTextPassword, this.password);
    }
}
