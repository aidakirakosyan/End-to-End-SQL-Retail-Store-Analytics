-- Query 1: Purchases made today
-- Business use: Monitor daily sales activity
SELECT * 
FROM purchases 
WHERE DATE(purchase_date) = CURDATE();

-- Query 2: Products added in the last week
-- Business use: Track new product introductions
SELECT * 
FROM products 
WHERE DATE(created_at) >= CURDATE() - INTERVAL 7 DAY;

-- Query 3: Products with category and manufacturer
-- Business use: Product classification for reporting
SELECT p.product_id, p.product_name, c.category_name, m.manufacturer_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- Query 4: Purchases with customer and store details
-- Business use: Customer purchase history and store-level analysis
SELECT p.purchase_id, p.purchase_date, c.customer_firstname, c.customer_lastname, s.store_name
FROM purchases p
JOIN customers c ON p.customer_id = c.customer_id
JOIN stores s ON p.store_id = s.store_id;

-- Query 5: Total revenue per product
-- Business use: Identify top revenue-generating products
SELECT p.product_id, p.product_name,
       COALESCE(SUM(pp.quantity * pp.purchase_price), 0) AS total_revenue
FROM products p
LEFT JOIN purchase_products pp ON p.product_id = pp.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Query 6: Total revenue per store
-- Business use: Compare store performance
SELECT s.store_id, s.store_name,
       COALESCE(SUM(pp.quantity * pp.purchase_price), 0) AS total_per_store
FROM stores s
LEFT JOIN purchases p ON s.store_id = p.store_id
LEFT JOIN purchase_products pp ON p.purchase_id = pp.purchase_id
GROUP BY s.store_id, s.store_name
ORDER BY total_per_store DESC;

-- Query 7: Top 5 products by quantity sold
-- Business use: Spot best-selling products
SELECT p.product_id, p.product_name,
       COALESCE(SUM(pp.quantity), 0) AS total_sold
FROM products p
LEFT JOIN purchase_products pp ON p.product_id = pp.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- Query 8: Customer purchase counts
-- Business use: Loyalty and engagement tracking
SELECT c.customer_id, c.customer_firstname, c.customer_lastname,
       COUNT(p.purchase_id) AS total_orders
FROM customers c
LEFT JOIN purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_firstname, c.customer_lastname
ORDER BY total_orders DESC;

-- Query 9: Customer segmentation
-- Business use: Classify customers into groups (VIP, inactive, new, etc.)
WITH customer_orders AS (
    SELECT c.customer_id, c.customer_firstname, c.customer_lastname,
           COUNT(p.purchase_id) AS total_orders,
           MAX(p.purchase_date) AS last_purchase_date,
           SUM(pp.quantity * pp.purchase_price) AS total_spent
    FROM customers c
    LEFT JOIN purchases p ON c.customer_id = p.customer_id
    LEFT JOIN purchase_products pp ON p.purchase_id = pp.purchase_id
    GROUP BY c.customer_id, c.customer_firstname, c.customer_lastname
),
segmented AS (
    SELECT customer_id, customer_firstname, customer_lastname,
           total_orders, last_purchase_date, total_spent,
           DATEDIFF(CURDATE(), last_purchase_date) AS recency_days,
           CASE 
               WHEN total_orders = 0 THEN 'JUST SIGNED UP'
               WHEN total_orders = 1 AND recency_days <= 30 THEN 'NEW'
               WHEN total_orders = 1 AND recency_days > 30 THEN 'ONE-TIME BUYER'
               WHEN total_orders > 5 AND total_spent > 100 THEN 'VIP'
               WHEN recency_days > 365 THEN 'INACTIVE'
               ELSE 'REGULAR'
           END AS customer_segment
    FROM customer_orders
)
SELECT * FROM segmented;

-- Query 10: Daily revenue trends
-- Business use: Monitor revenue patterns over time
SELECT DATE(p.purchase_date) AS purchase_day,
       SUM(pp.quantity * pp.purchase_price) AS daily_revenue
FROM purchases p
JOIN purchase_products pp ON p.purchase_id = pp.purchase_id
GROUP BY purchase_day
ORDER BY purchase_day;

-- Query 11: Average order value
-- Business use: Measure customer spending behavior
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT SUM(pp.quantity * pp.purchase_price) AS order_total
    FROM purchases p
    JOIN purchase_products pp ON p.purchase_id = pp.purchase_id
    GROUP BY p.purchase_id
) AS order_totals;