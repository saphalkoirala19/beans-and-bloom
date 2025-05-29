// OrderModel.java
package com.example.demo.models;

import java.sql.Timestamp;

/**
 * The OrderModel class represents a customer's order.
 * It contains information about the order ID, customer ID, status, total amount,
 * number of items, and the date the order was placed.
 */
public class OrderModel {

    // Unique identifier for the order
    private int id;

    // ID of the user (customer) who placed the order
    private int userId;

    // Date and time when the order was placed
    private Timestamp orderDate;

    // Current status of the order (e.g., PENDING, COMPLETED)
    private Status status;

    // Total amount for the order
    private double totalAmount;

    // Total quantity of items in the order
    private int quantity;

    // (Optional) Customer name (useful for joins or display purposes)
    private String customerName;

    /**
     * Enum representing possible order statuses.
     */
    public enum Status {
        PENDING,
        ON_THE_WAY,
        CANCELLED,
        COMPLETED
    }

    // Getters and Setters

    /**
     * Returns the order ID.
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the order ID.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Returns the ID of the user who placed the order.
     */
    public int getUserId() {
        return userId;
    }

    /**
     * Sets the ID of the user who placed the order.
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }

    /**
     * Returns the timestamp when the order was placed.
     */
    public Timestamp getOrderDate() {
        return orderDate;
    }

    /**
     * Sets the timestamp when the order was placed.
     */
    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    /**
     * Returns the current status of the order.
     */
    public Status getStatus() {
        return status;
    }

    /**
     * Sets the current status of the order.
     */
    public void setStatus(Status status) {
        this.status = status;
    }

    /**
     * Returns the total amount of the order.
     */
    public double getTotalAmount() {
        return totalAmount;
    }

    /**
     * Sets the total amount of the order.
     */
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    /**
     * Returns the total quantity of items in the order.
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Sets the total quantity of items in the order.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Returns the name of the customer (optional).
     */
    public String getCustomerName() {
        return customerName;
    }

    /**
     * Sets the name of the customer (optional).
     */
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
