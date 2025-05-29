package com.example.demo.models;

/**
 * The OrderItemModel class represents a single item entry within a customer's order.
 * Each object of this class stores information such as the item ID, name, price,
 * quantity ordered, and the corresponding order ID it belongs to.
 */
public class OrderItemModel {

    // Unique identifier for this order item entry
    private int id;

    // ID of the order this item belongs to
    private int orderId;

    // ID of the item (referencing an item in the items table)
    private int itemId;

    // Name of the item
    private String itemName;

    // Price of the item at the time of the order
    private double itemPrice;

    // Quantity of the item ordered
    private int quantity;

    // Getter and setter methods

    /**
     * Returns the ID of this order item.
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the ID of this order item.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Returns the order ID this item belongs to.
     */
    public int getOrderId() {
        return orderId;
    }

    /**
     * Sets the order ID this item belongs to.
     */
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    /**
     * Returns the item ID of this order item.
     */
    public int getItemId() {
        return itemId;
    }

    /**
     * Sets the item ID of this order item.
     */
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    /**
     * Returns the name of the item.
     */
    public String getName() {
        return itemName;
    }

    /**
     * Sets the name of the item.
     */
    public void setName(String itemName) {
        this.itemName = itemName;
    }

    /**
     * Returns the price of the item.
     */
    public double getPrice() {
        return itemPrice;
    }

    /**
     * Sets the price of the item.
     */
    public void setPrice(double itemPrice) {
        this.itemPrice = itemPrice;
    }

    /**
     * Returns the quantity of the item ordered.
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Sets the quantity of the item ordered.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
