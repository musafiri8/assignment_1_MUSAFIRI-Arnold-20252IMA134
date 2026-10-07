-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- Student Name : MUSAFIRI Arnold
-- Student ID   : 20252IMA134
-- Group        : Group I / Monday Group I
-- Tool / DBMS  : Oracle SQL Developer Version 26.2.0.186.2220 (Oracle PL/SQL)
-- Target Repo  : assignment_1_musafiri_arnold-20252IMA134
-- Currency     : Rwandan Francs (RWF)
-- Naming       : Authentic Rwandan Customer Names & Locations
-- =============================================================================

--------------------------------------------------------------------------------
-- SECTION 1: CLEANUP / DROP TABLES (SAFE EXECUTION)
--------------------------------------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE order_items CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE orders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE products CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

--------------------------------------------------------------------------------
-- SECTION 2: TABLE SCHEMA CREATION
--------------------------------------------------------------------------------
CREATE TABLE customers (
  customer_id   NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100) NOT NULL,
  email         VARCHAR2(100),
  city          VARCHAR2(50)
);

CREATE TABLE products (
  product_id   NUMBER PRIMARY KEY,
  product_name VARCHAR2(100) NOT NULL,
  category     VARCHAR2(50) NOT NULL,
  price        NUMBER(10,2) NOT NULL  -- Unit price in Rwandan Francs (RWF)
);

CREATE TABLE orders (
  order_id    NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  order_date  DATE NOT NULL
);

CREATE TABLE order_items (
  order_item_id NUMBER PRIMARY KEY,
  order_id      NUMBER REFERENCES orders(order_id),
  product_id    NUMBER REFERENCES products(product_id),
  quantity      NUMBER NOT NULL
);

--------------------------------------------------------------------------------
-- SECTION 3: DATA POPULATION
--------------------------------------------------------------------------------
-- 1. Insert Customers (6 records - Rwandan Names & Cities)
INSERT INTO customers VALUES (1, 'Mugisha Keza',       'mugishakeza@gmail.com',       'Kigali');
INSERT INTO customers VALUES (2, 'Habimana Jean',      'habimanajean@gmail.com',      'Musanze');
INSERT INTO customers VALUES (3, 'Uwase Divine',       'uwasedivine@gmail.com',       'Rubavu');
INSERT INTO customers VALUES (4, 'Manzi Eric',         'manzieric@gmail.com',         'Huye');
INSERT INTO customers VALUES (5, 'Ishimwe Chantal',    'ishimwechantal@gmail.com',    'Kayonza');
INSERT INTO customers VALUES (6, 'Niyonzima Patrick',  'niyonzimapatrick@gmail.com',  'Rusizi');

-- 2. Insert Products (Rwandan products - Prices in Rwandan Francs RWF)
INSERT INTO products VALUES (1, 'Amata 1L',       'Dairy',     1500.00);
INSERT INTO products VALUES (2, 'Amavuta 500g',   'Dairy',     4250.00);
INSERT INTO products VALUES (3, 'Umugati',        'Bakery',    3500.00);
INSERT INTO products VALUES (4, 'Igitoki (Bunch)','Produce',   1250.00);
INSERT INTO products VALUES (5, 'Umuceri 5kg',    'Grocery',  12000.00);
INSERT INTO products VALUES (6, 'Amashaza 1kg',   'Grocery',   8750.00);
INSERT INTO products VALUES (7, 'Fanta 1L',       'Beverages', 2800.00);
INSERT INTO products VALUES (8, 'Amazi x6',       'Beverages', 4600.00);

-- 3. Insert Orders (15 orders across multiple dates)
INSERT INTO orders VALUES (101, 1, DATE '2026-01-05');
INSERT INTO orders VALUES (102, 2, DATE '2026-01-08');
INSERT INTO orders VALUES (103, 1, DATE '2026-01-19');
INSERT INTO orders VALUES (104, 3, DATE '2026-02-02');
INSERT INTO orders VALUES (105, 4, DATE '2026-02-10');
INSERT INTO orders VALUES (106, 2, DATE '2026-02-14');
INSERT INTO orders VALUES (107, 1, DATE '2026-03-01');
INSERT INTO orders VALUES (108, 5, DATE '2026-03-05');
INSERT INTO orders VALUES (109, 3, DATE '2026-03-18');
INSERT INTO orders VALUES (110, 2, DATE '2026-04-02');
INSERT INTO orders VALUES (111, 4, DATE '2026-04-15');
INSERT INTO orders VALUES (112, 1, DATE '2026-04-22');
INSERT INTO orders VALUES (113, 3, DATE '2026-05-06');
INSERT INTO orders VALUES (114, 5, DATE '2026-05-20');
INSERT INTO orders VALUES (115, 2, DATE '2026-06-03');

-- 4. Insert Order Items (25 order items)
INSERT INTO order_items VALUES (1,  101, 1, 4);
INSERT INTO order_items VALUES (2,  101, 3, 2);
INSERT INTO order_items VALUES (3,  102, 5, 1);
INSERT INTO order_items VALUES (4,  102, 7, 3);
INSERT INTO order_items VALUES (5,  103, 2, 2);
INSERT INTO order_items VALUES (6,  103, 4, 6);
INSERT INTO order_items VALUES (7,  104, 6, 1);
INSERT INTO order_items VALUES (8,  104, 8, 2);
INSERT INTO order_items VALUES (9,  105, 1, 6);
INSERT INTO order_items VALUES (10, 105, 3, 1);
INSERT INTO order_items VALUES (11, 106, 5, 2);
INSERT INTO order_items VALUES (12, 107, 7, 2);
INSERT INTO order_items VALUES (13, 107, 2, 1);
INSERT INTO order_items VALUES (14, 108, 4, 10);
INSERT INTO order_items VALUES (15, 108, 8, 1);
INSERT INTO order_items VALUES (16, 109, 6, 2);
INSERT INTO order_items VALUES (17, 109, 1, 3);
INSERT INTO order_items VALUES (18, 110, 3, 3);
INSERT INTO order_items VALUES (19, 111, 5, 1);
INSERT INTO order_items VALUES (20, 111, 7, 4);
INSERT INTO order_items VALUES (21, 112, 8, 3);
INSERT INTO order_items VALUES (22, 112, 4, 4);
INSERT INTO order_items VALUES (23, 113, 2, 3);
INSERT INTO order_items VALUES (24, 114, 6, 1);
INSERT INTO order_items VALUES (25, 115, 5, 1);

COMMIT;

--------------------------------------------------------------------------------
-- SECTION 4: ASSIGNMENT QUERIES
--------------------------------------------------------------------------------

-- =============================================================================
-- JOIN QUERY 1: INNER JOIN (orders + customers)
-- Purpose: List every order with the customer's name, city, and order date.
-- =============================================================================
SELECT o.order_id,
       c.customer_name,
       c.city,
       o.order_date
FROM   orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date, o.order_id;


-- =============================================================================
-- JOIN QUERY 2: INNER JOIN (order_items + products)
-- Purpose: List every order item with product name, category, price (RWF), quantity, and line total (RWF).
-- =============================================================================
SELECT oi.order_item_id,
       oi.order_id,
       p.product_name,
       p.category,
       p.price AS price_rwf,
       oi.quantity,
       (p.price * oi.quantity) AS line_total_rwf
FROM   order_items oi
INNER JOIN products p ON p.product_id = oi.product_id
ORDER BY oi.order_item_id;


-- =============================================================================
-- JOIN QUERY 3: LEFT JOIN (customers + orders)
-- Purpose: List all customers and their orders where they exist, including customers with no orders.
-- =============================================================================
SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.order_date
FROM   customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;


-- =============================================================================
-- CTE QUERY 1: CUSTOMERS ABOVE AVERAGE SPEND (RWF)
-- Purpose: Calculate each customer's total spend in RWF using a CTE, 
--          and return customers spending above the average customer spend.
-- =============================================================================
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend_rwf
    FROM   customers c
    JOIN   orders o       ON o.customer_id = c.customer_id
    JOIN   order_items oi ON oi.order_id   = o.order_id
    JOIN   products p     ON p.product_id  = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_spend_rwf
FROM   customer_totals
WHERE  total_spend_rwf > (SELECT AVG(total_spend_rwf) FROM customer_totals)
ORDER BY total_spend_rwf DESC;


-- =============================================================================
-- WINDOW FUNCTION QUERY 1: RANK CUSTOMERS BY SPEND (RWF)
-- Purpose: Rank customers by total amount spent in Rwandan Francs, highest first.
-- =============================================================================
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend_rwf
    FROM   customers c
    JOIN   orders o       ON o.customer_id = c.customer_id
    JOIN   order_items oi ON oi.order_id   = o.order_id
    JOIN   products p     ON p.product_id  = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name,
       total_spend_rwf,
       RANK() OVER (ORDER BY total_spend_rwf DESC) AS spend_rank
FROM   customer_totals
ORDER BY spend_rank;


-- =============================================================================
-- WINDOW FUNCTION QUERY 2: NUMBER CUSTOMER ORDERS
-- Purpose: Number each customer's orders sequentially in the order placed.
-- =============================================================================
SELECT c.customer_name,
       o.order_id,
       o.order_date,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id
           ORDER BY o.order_date, o.order_id
       ) AS order_number
FROM   orders o
JOIN   customers c ON c.customer_id = o.customer_id
ORDER BY c.customer_name, order_number;


-- =============================================================================
-- WINDOW FUNCTION QUERY 3: RUNNING TOTAL OF REVENUE (RWF)
-- Purpose: Show a running total of revenue in Rwandan Francs over time, ordered by order date.
-- =============================================================================
WITH order_revenue AS (
    SELECT o.order_id,
           o.order_date,
           SUM(oi.quantity * p.price) AS order_total_rwf
    FROM   orders o
    JOIN   order_items oi ON oi.order_id  = o.order_id
    JOIN   products p     ON p.product_id = oi.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT order_id,
       order_date,
       order_total_rwf,
       SUM(order_total_rwf) OVER (
           ORDER BY order_date, order_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_revenue_rwf
FROM   order_revenue
ORDER BY order_date, order_id;


-- =============================================================================
-- WINDOW FUNCTION QUERY 4: DAYS BETWEEN PREVIOUS & CURRENT ORDER
-- Purpose: For each customer with more than one order, show days between current and previous order.
-- =============================================================================
WITH order_gaps AS (
    SELECT c.customer_name,
           o.order_id,
           o.order_date,
           LAG(o.order_date) OVER (
               PARTITION BY o.customer_id
               ORDER BY o.order_date, o.order_id
           ) AS previous_order_date,
           COUNT(*) OVER (PARTITION BY o.customer_id) AS orders_per_customer
    FROM   orders o
    JOIN   customers c ON c.customer_id = o.customer_id
)
SELECT customer_name,
       order_id,
       order_date,
       previous_order_date,
       ROUND(order_date - previous_order_date) AS days_since_previous
FROM   order_gaps
WHERE  orders_per_customer > 1
ORDER BY customer_name, order_date;
