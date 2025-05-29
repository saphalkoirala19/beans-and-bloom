-- Database initialization script

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS user_db;

-- Use the database
USE user_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    profile_picture MEDIUMBLOB
    );

-- Create  table items table
CREATE TABLE IF NOT EXISTS items (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     name VARCHAR(100) NOT NULL,
                                     description TEXT,
                                     price DECIMAL(10, 2) NOT NULL,
                                     quantity INT NOT NULL DEFAULT 0,
                                     category ENUM('DRINKS', 'DESSERT', 'BAKERY', 'OTHER') NOT NULL,
                                     status ENUM('AVAILABLE', 'UNAVAILABLE') NOT NULL DEFAULT 'AVAILABLE',
                                     image MEDIUMBLOB
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
                                      id INT AUTO_INCREMENT PRIMARY KEY,
                                      user_id INT NOT NULL,
                                      order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                      status ENUM('PENDING', 'ON-THE-WAY', 'CANCELLED') NOT NULL,
                                      total_amount DECIMAL(10, 2) NOT NULL,
                                      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
                                           id INT AUTO_INCREMENT PRIMARY KEY,
                                           order_id INT NOT NULL,
                                           item_id INT NOT NULL,
                                           quantity INT NOT NULL,
                                           price_at_order DECIMAL(10, 2) NOT NULL,
                                           FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                                           FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);



-- Insert sample admin user if not exists
INSERT INTO users (name, email, password, role)
SELECT 'Admin User', 'admin@example.com', 'admin123', 'admin'
    WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@example.com');

-- Insert sample regular user if not exists
INSERT INTO users (name, email, password, role)
SELECT 'Student User', 'student@example.com', 'student123', 'user'
    WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'student@example.com');

-- Insert sample items if not exists
INSERT INTO items (name, description, price, quantity, category, status)
SELECT 'Espresso', 'Strong black coffee', 2.50, 10, 'DRINKS', 'AVAILABLE'
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Espresso');

INSERT INTO items (name, description, price, quantity, category, status)
SELECT 'Chocolate Cake', 'Rich chocolate dessert', 4.50, 5, 'DESSERT', 'AVAILABLE'
WHERE NOT EXISTS (SELECT 1 FROM items WHERE name = 'Chocolate Cake');








