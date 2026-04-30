CREATE DATABASE retail_store;
USE retail_store;

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE manufacturers (
    manufacturer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    manufacturer_name VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price DECIMAL(10 , 2 ) NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE RESTRICT,
    FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers (manufacturer_id)
        ON DELETE RESTRICT
);

CREATE TABLE stores (
    store_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    store_address VARCHAR(255) NOT NULL
);

CREATE TABLE deliveries (
    delivery_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    delivery_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    store_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (store_id)
        REFERENCES stores (store_id)
        ON DELETE CASCADE
);

CREATE TABLE delivery_products (
    delivery_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    PRIMARY KEY (delivery_id , product_id),
    FOREIGN KEY (delivery_id)
        REFERENCES deliveries (delivery_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT,
    INDEX idx_product_id (product_id)
);

CREATE TABLE customers (
    customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_firstname VARCHAR(45) NOT NULL,
    customer_lastname VARCHAR(45) NOT NULL,
    customer_email VARCHAR(255) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (customer_id, customer_firstname, customer_lastname, customer_email)
VALUES (1, 'Guest', 'Customer', 'guest@gmail.com');

CREATE TABLE purchases (
    purchase_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT UNSIGNED NOT NULL DEFAULT 1,
    store_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON DELETE RESTRICT,
    FOREIGN KEY (store_id)
        REFERENCES stores (store_id)
        ON DELETE CASCADE
);

CREATE TABLE purchase_products (
    purchase_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    purchase_price DECIMAL(10 , 2 ) NOT NULL,
    PRIMARY KEY (purchase_id , product_id),
    FOREIGN KEY (purchase_id)
        REFERENCES purchases (purchase_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT,
    INDEX idx_product_id (product_id)
);

