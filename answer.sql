-- Simple E-commerce Database
CREATE DATABASE IF NOT EXISTS simple_ecommerce;
USE simple_ecommerce;

-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order items table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@email.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@email.com', '123-456-7891'),
('Mike', 'Johnson', 'mike.johnson@email.com', '123-456-7892');

-- Insert sample products
INSERT INTO products (product_name, description, price, stock_quantity, category) VALUES
('Laptop', '15-inch laptop with 8GB RAM', 999.99, 50, 'Electronics'),
('Smartphone', 'Latest smartphone with 128GB storage', 699.99, 100, 'Electronics'),
('T-Shirt', 'Cotton t-shirt, various sizes', 24.99, 200, 'Clothing'),
('Book', 'Bestselling novel', 14.99, 75, 'Books'),
('Headphones', 'Wireless noise-cancelling headphones', 199.99, 30, 'Electronics');

-- Insert sample orders
INSERT INTO orders (customer_id, total_amount, shipping_address, status) VALUES
(1, 1214.98, '123 Main St, City, State 12345', 'delivered'),
(2, 44.98, '456 Oak Ave, City, State 12345', 'processing'),
(3, 699.99, '789 Pine Rd, City, State 12345', 'pending');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),  -- Laptop
(1, 5, 1, 199.99),  -- Headphones
(2, 3, 1, 24.99),   -- T-Shirt
(2, 4, 1, 14.99),   -- Book
(3, 2, 1, 699.99);  -- Smartphone


-- E-commerce Database with All Relationship Types
CREATE DATABASE IF NOT EXISTS ecommerce_relationships;
USE ecommerce_relationships;

-- 1. ONE-TO-ONE Relationship Example
-- Each customer has exactly one profile (and each profile belongs to one customer)

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL,  -- UNIQUE constraint makes it One-to-One
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    preferences TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 2. ONE-TO-MANY Relationship Examples
-- One customer can have many orders
-- One category can have many products

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,  -- Many products belong to one category
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,  -- Many orders belong to one customer
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. MANY-TO-MANY Relationship Examples
-- Many products can be in many orders (through order_items)
-- Many customers can wishlist many products (through wishlists)

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE KEY unique_order_product (order_id, product_id)  -- Prevents duplicate items in same order
);

CREATE TABLE wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_customer_product (customer_id, product_id)  -- Prevents duplicate wishlist items
);

-- 4. SELF-REFERENCING Relationship (Hierarchical)
-- Categories can have sub-categories (parent-child relationship)

ALTER TABLE categories ADD COLUMN parent_category_id INT NULL;
ALTER TABLE categories ADD FOREIGN KEY (parent_category_id) REFERENCES categories(category_id);

-- 5. Insert Sample Data

-- Insert categories (with hierarchical structure)
INSERT INTO categories (category_name, description, parent_category_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Computers', 'Computers and laptops', 1),
('Smartphones', 'Mobile phones', 1),
('Clothing', 'Fashion and apparel', NULL),
('Men''s Clothing', 'Clothing for men', 4),
('Women''s Clothing', 'Clothing for women', 4);

-- Insert customers
INSERT INTO customers (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@email.com'),
('Jane', 'Smith', 'jane.smith@email.com'),
('Mike', 'Johnson', 'mike.johnson@email.com');

-- Insert customer profiles (One-to-One)
INSERT INTO customer_profiles (customer_id, date_of_birth, gender, preferences) VALUES
(1, '1990-05-15', 'Male', '{"newsletter": true, "notifications": false}'),
(2, '1985-12-20', 'Female', '{"newsletter": false, "notifications": true}'),
(3, '1992-08-10', 'Male', '{"newsletter": true, "notifications": true}');

-- Insert products
INSERT INTO products (product_name, description, price, category_id, stock_quantity) VALUES
('MacBook Pro', '15-inch laptop', 1499.99, 2, 50),
('iPhone 15', 'Latest smartphone', 999.99, 3, 100),
('Gaming Laptop', 'High-performance gaming', 1299.99, 2, 30),
('Android Phone', 'Latest Android smartphone', 799.99, 3, 80),
('Men''s T-Shirt', 'Cotton t-shirt', 24.99, 5, 200),
('Women''s Dress', 'Summer dress', 49.99, 6, 150);

-- Insert orders (One-to-Many)
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 2499.98, 'delivered'),  -- John's order
(2, 49.99, 'confirmed'),     -- Jane's order
(1, 799.99, 'pending'),      -- John's second order
(3, 1299.99, 'shipped');     -- Mike's order

-- Insert order items (Many-to-Many)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1499.99),  -- MacBook in order 1
(1, 2, 1, 999.99),   -- iPhone in order 1
(2, 6, 1, 49.99),    -- Dress in order 2
(3, 4, 1, 799.99),   -- Android phone in order 3
(4, 3, 1, 1299.99);  -- Gaming laptop in order 4

-- Insert wishlists (Many-to-Many)
INSERT INTO wishlists (customer_id, product_id) VALUES
(1, 3),  -- John wishes Gaming Laptop
(1, 6),  -- John wishes Women's Dress (maybe for gift)
(2, 1),  -- Jane wishes MacBook Pro
(2, 5),  -- Jane wishes Men's T-Shirt (maybe for gift)
(3, 2),  -- Mike wishes iPhone
(3, 3);  -- Mike wishes Gaming Laptop

-- Create indexes for better performance
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_wishlists_customer ON wishlists(customer_id);
CREATE INDEX idx_wishlists_product ON wishlists(product_id);
CREATE INDEX idx_categories_parent ON categories(parent_category_id);

-- Demonstration Queries

-- One-to-One: Get customer with their profile
SELECT c.first_name, c.email, cp.date_of_birth, cp.gender 
FROM customers c 
JOIN customer_profiles cp ON c.customer_id = cp.customer_id;

-- One-to-Many: Get all orders for a specific customer
SELECT c.first_name, o.order_id, o.total_amount, o.status 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE c.email = 'john.doe@email.com';

-- Many-to-Many: Get all products in an order
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.order_id = 1;

-- Many-to-Many: Get wishlist items for a customer
SELECT c.first_name, p.product_name, p.price 
FROM customers c 
JOIN wishlists w ON c.customer_id = w.customer_id 
JOIN products p ON w.product_id = p.product_id 
WHERE c.email = 'john.doe@email.com';

-- Self-referencing: Get categories with their parent categories
SELECT child.category_name as subcategory, 
       parent.category_name as parent_category 
FROM categories child 
LEFT JOIN categories parent ON child.parent_category_id = parent.category_id;