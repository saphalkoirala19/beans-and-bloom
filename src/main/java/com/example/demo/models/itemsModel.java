package com.example.demo.models;



import java.io.Serializable;

/**
 * The itemsModel class represents an item in the system, such as a product that can be
 * categorized, priced, and managed by its availability status and quantity.
 * <p>
 * This class supports serialization and provides business logic methods to determine
 * availability and update status based on quantity.
 */
public class itemsModel implements Serializable {

    /**
     * Enumeration representing item categories.
     */
    public enum Category {
        DRINKS, DESSERT, BAKERY, OTHER
    }

    /**
     * Enumeration representing item availability status.
     */
    public enum Status {
        AVAILABLE, UNAVAILABLE
    }

    // Unique identifier for the item
    private int id;

    // Name of the item
    private String name;

    // Description of the item
    private String description;

    // Price of the item
    private double price;

    // Quantity available
    private int quantity;

    // Category of the item
    private Category category;

    // Availability status of the item
    private Status status;

    // Image data (as byte array) of the item
    private byte[] image;

    /**
     * Default constructor
     */
    public itemsModel() {
    }

    // Getter and setter methods

    /**
     * Returns the ID of the item.
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the ID of the item.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Returns the name of the item.
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name of the item.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the description of the item.
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the description of the item.
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Returns the price of the item.
     */
    public double getPrice() {
        return price;
    }

    /**
     * Sets the price of the item.
     */
    public void setPrice(double price) {
        this.price = price;
    }

    /**
     * Returns the available quantity of the item.
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Sets the available quantity of the item.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Returns the category of the item.
     */
    public Category getCategory() {
        return category;
    }

    /**
     * Sets the category of the item.
     */
    public void setCategory(Category category) {
        this.category = category;
    }

    /**
     * Returns the current availability status of the item.
     */
    public Status getStatus() {
        return status;
    }

    /**
     * Sets the availability status of the item.
     */
    public void setStatus(Status status) {
        this.status = status;
    }

    /**
     * Returns the image data of the item.
     */
    public byte[] getImage() {
        return image;
    }

    /**
     * Sets the image data of the item.
     */
    public void setImage(byte[] image) {
        this.image = image;
    }

    // Business logic methods

    /**
     * Checks if the item is available for sale.
     *
     * @return true if the item is AVAILABLE and quantity is more than 0; false otherwise
     */
    public boolean isAvailable() {
        return status == Status.AVAILABLE && quantity > 0;
    }

    /**
     * Updates the item's availability status based on the current quantity.
     * If quantity is 0 or less, the status is set to UNAVAILABLE.
     * If quantity is positive and the item was previously UNAVAILABLE, it is set to AVAILABLE.
     */
    public void updateStatusBasedOnQuantity() {
        if (quantity <= 0) {
            status = Status.UNAVAILABLE;
        } else if (status == Status.UNAVAILABLE) {
            status = Status.AVAILABLE;
        }
    }
}
