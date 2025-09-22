# E-commerce Database Management System

## 📋 Project Overview

A comprehensive relational database system for managing an e-commerce platform. This database supports customer management, product catalog, order processing, inventory tracking, and customer wishlists.

## 🗄️ Database Schema

### Tables Structure

#### Core Tables
- **`customers`** - Stores customer information
- **`customer_profiles`** - Customer demographic data (One-to-One relationship)
- **`categories`** - Product categorization with hierarchical support
- **`products`** - Product catalog with pricing and inventory
- **`orders`** - Order management and tracking
- **`order_items`** - Individual items within orders (Many-to-Many relationship)
- **`wishlists`** - Customer product wishlists (Many-to-Many relationship)

## 🔗 Relationship Types

### 1. One-to-One Relationship
**`customers` ↔ `customer_profiles`**
- Each customer has exactly one profile
- Implemented with UNIQUE foreign key constraint

### 2. One-to-Many Relationships
- **`customers` → `orders`** - One customer can place many orders
- **`categories` → `products`** - One category can contain many products

### 3. Many-to-Many Relationships
- **`orders` ↔ `products`** through `order_items` junction table
- **`customers` ↔ `products`** through `wishlists` junction table

### 4. Self-Referencing Relationship
- **`categories` → `categories`** - Hierarchical category structure (parent-child relationships)

## 🚀 Installation & Setup

### Prerequisites
- MySQL Server 5.7 or higher
- MySQL Workbench or command-line client

### Installation Steps

1. **Clone or download the database script**
2. **Run the SQL script in MySQL:**
   ```sql
   source path/to/ecommerce_database.sql
   ```
   Or copy-paste the entire script into your MySQL client

3. **Verify the database creation:**
   ```sql
   SHOW DATABASES;
   USE ecommerce_relationships;
   SHOW TABLES;
   ```

## 📊 Sample Data

The database comes pre-loaded with sample data including:

### Customers
- John Doe (john.doe@email.com)
- Jane Smith (jane.smith@email.com)
- Mike Johnson (mike.johnson@email.com)

### Product Categories
- Electronics
  - Computers
  - Smartphones
- Clothing
  - Men's Clothing
  - Women's Clothing

### Products
- MacBook Pro ($1499.99)
- iPhone 15 ($999.99)
- Gaming Laptop ($1299.99)
- Various clothing items

## 🔍 Example Queries

### 1. Get Customer Orders
```sql
SELECT c.first_name, o.order_id, o.total_amount, o.status 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
WHERE c.email = 'john.doe@email.com';
```

### 2. View Order Details
```sql
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.order_id = 1;
```

### 3. Check Customer Wishlist
```sql
SELECT c.first_name, p.product_name, p.price 
FROM customers c 
JOIN wishlists w ON c.customer_id = w.customer_id 
JOIN products p ON w.product_id = p.product_id 
WHERE c.email = 'john.doe@email.com';
```

### 4. Category Hierarchy
```sql
SELECT child.category_name as subcategory, 
       parent.category_name as parent_category 
FROM categories child 
LEFT JOIN categories parent ON child.parent_category_id = parent.category_id;
```

## 🛠️ Database Operations

### Adding New Customers
```sql
INSERT INTO customers (first_name, last_name, email) 
VALUES ('Sarah', 'Wilson', 'sarah.wilson@email.com');
```

### Adding New Products
```sql
INSERT INTO products (product_name, description, price, category_id, stock_quantity) 
VALUES ('Tablet', '10-inch Android tablet', 299.99, 3, 50);
```

### Placing Orders
```sql
-- Create order header
INSERT INTO orders (customer_id, total_amount) VALUES (1, 299.99);

-- Add order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) 
VALUES (LAST_INSERT_ID(), 1, 1, 299.99);
```

## 📈 Indexes for Performance

The database includes optimized indexes for:
- Customer email searches
- Product category filtering
- Order status and date queries
- Wishlist and order item lookups

## 🎯 Business Use Cases

### Inventory Management
- Track stock levels
- Monitor low inventory alerts
- Manage product categories

### Sales Analytics
- Customer order history
- Product popularity analysis
- Revenue reporting

### Customer Relationship Management
- Customer profiles and preferences
- Wishlist management
- Order tracking

## 🔒 Data Integrity Features

- **Primary Keys** for unique identification
- **Foreign Keys** for relational integrity
- **Unique Constraints** for data consistency
- **Check Constraints** for valid data ranges
- **Cascading Deletes** for maintaining referential integrity

## 📝 Maintenance Tasks

### Regular Backups
```sql
-- Export database
mysqldump -u username -p ecommerce_relationships > backup.sql
```

### Performance Monitoring
```sql
-- Check table sizes
SELECT table_name, table_rows 
FROM information_schema.tables 
WHERE table_schema = 'ecommerce_relationships';
```

## 🤝 Contributing

To extend this database system:

1. Follow the existing naming conventions
2. Maintain referential integrity with proper foreign keys
3. Include appropriate indexes for new tables
4. Add sample data for testing
