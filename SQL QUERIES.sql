/*
==============================================================================
                     SALES DATABASE SETUP 
==============================================================================

Tables   : 
  - sales: Order-level data (customers , orderdetails , orders , products)

Usage    : Run this before executing query files.
==============================================================================
*/
-- . Create the database
CREATE DATABASE SalesDB;

-- ================================
-- 1. Create Customers Table
-- ================================

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);

-- ================================
-- 2. Create Products Table
-- ================================

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- ================================
-- 3. Create Orders Table
-- ================================

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);

-- ================================
-- 4. Create OrderDetails Table
-- ================================

CREATE TABLE OrderDetails (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_orderdetails_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT fk_orderdetails_product
    FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderdetails;

# SalesDB SQL Analysis Portfolio
# 1. Total Revenue by Product Category
# Business Requirement: - The category management team wants to analyze revenue performance by product category.
    SELECT
    p.product_category,
    SUM(od.quantity * p.price) AS total_revenue
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;

# Output:
#product_category	total_revenue
#Electronics	         500000

#2. Top 5 Products by Quantity Sold
#Business Requirement:-The merchandising team wants to identify the best-selling products.
SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

#3. Customers With More Than 5 Orders
#Business Requirement:-The customer loyalty team wants customers eligible for rewards.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id)>5
ORDER BY total_orders DESC;

#4. Monthly Sales Trend Analysis
#Business Requirement:-Finance wants monthly revenue and order volume trends.
SELECT
YEAR(o.order_date) AS sales_year,
MONTH(o.order_date) AS sales_month,
SUM(od.quantity * p.price) AS revenue,
COUNT(DISTINCT o.order_id) AS order_volume
FROM Orders o
INNER JOIN OrderDetails od
ON o.order_id=od.order_id
INNER JOIN Products p
ON od.product_id=p.product_id
GROUP BY
YEAR(o.order_date),
MONTH(o.order_date)
ORDER BY
sales_year,
sales_month;

#5. Last 6 Months Sales Performance
#Business Requirement:-Management wants recent sales performance analysis.
SELECT
YEAR(o.order_date) AS year,
MONTH(o.order_date) AS month,
SUM(od.quantity*p.price) AS revenue,
COUNT(DISTINCT o.order_id) AS orders
FROM Orders o
JOIN OrderDetails od
ON o.order_id=od.order_id
JOIN Products p
ON od.product_id=p.product_id
WHERE o.order_date >= DATE_SUB(CURDATE(),INTERVAL 6 MONTH)
GROUP BY
YEAR(o.order_date),
MONTH(o.order_date)
ORDER BY year,month;

#6. Revenue Contribution by Top 10 Customers
#Business Requirement:-Sales leadership wants customers contributing the highest revenue
SELECT
c.customer_name,
SUM(od.quantity*p.price) AS customer_revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
JOIN OrderDetails od
ON o.order_id=od.order_id
JOIN Products p
ON od.product_id=p.product_id
GROUP BY c.customer_name
ORDER BY customer_revenue DESC
LIMIT 10;

#7. Highest Revenue Product Category
#Business Requirement:-Management wants to identify the highest revenue-generating category
SELECT
p.product_category,
SUM(od.quantity*p.price) AS revenue
FROM Products p
JOIN OrderDetails od
ON p.product_id=od.product_id
GROUP BY p.product_category
ORDER BY revenue DESC
LIMIT 1;

#8. Average Order Value by Customer
#Business Requirement:-Business analysts want to measure customer spending value.
  SELECT
c.customer_name,
ROUND(AVG(o.amount),2) AS average_order_value
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name
ORDER BY average_order_value DESC;

#9. Products Never Ordered
#Business Requirement:-Inventory team wants products that have no sales history.
SELECT
p.product_id,
p.product_name
FROM Products p
LEFT JOIN OrderDetails od
ON p.product_id=od.product_id
WHERE od.product_id IS NULL;

#10. Customers Who Did Not Purchase in Last Year
#Business Requirement:-Retention team wants inactive customers.
SELECT
c.customer_id,
c.customer_name,
MAX(o.order_date) AS last_purchase_date
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY
c.customer_id,
c.customer_name
HAVING MAX(o.order_date) < 
DATE_SUB(CURDATE(),INTERVAL 1 YEAR);

#11. Top 3 Products by Profit
#Business Requirement:-Management wants products generating highest profit.
SELECT 
    COUNT(*) AS total_rows,
    COUNT(cost) AS cost_available
FROM Products;
SET SQL_SAFE_UPDATES = 0;
UPDATE Products
SET cost = ROUND(price * 0.70,2)
WHERE price IS NOT NULL;
SELECT
p.product_name,
SUM(od.quantity * p.price)-
SUM(od.quantity * p.cost) AS profit
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 3;




customers (2).csv
Spreadsheet

orderdetails.csv
Spreadsheet

orders (2).csv
Spreadsheet

products (1).csv
Spreadsheet

SalesDB Questions.docx
Document
/help me create prompt for writing SQL queries mentioned in word doc and cover the queries related to a. Use EXTRACT(MONTH FROM order_date) for month. b. GROUP BY year/month. c. Use SUM() for revenue. d. COUNT(DISTINCT order_id) for volume. e. Use ORDER BY for sorting. f. Limit results for specific time periods. 

The issue is caused by datatype mismatch between primary key columns and foreign key columns.

Your script is written in PostgreSQL style (SERIAL, NUMERIC), but the error:

Error Code: 3780. Referencing column 'customer_id' and referenced column 'customer_id' in foreign key constraint 'orders_ibfk_1' are incompatible.
is a MySQL Workbench error.

In MySQL:

SERIAL is not treated like PostgreSQL SERIAL.

SERIAL internally becomes BIGINT UNSIGNED AUTO_INCREMENT.

Your foreign key column is:

customer_id INT NOT NULL
but your parent table has:

customer_id BIGINT UNSIGNED
Therefore:

Customers.customer_id  → BIGINT UNSIGNED
Orders.customer_id     → INT
Mismatch = Error 3780.

Fixed MySQL Version
Use INT AUTO_INCREMENT consistently for all primary keys.

-- ================================
-- 1. Create Customers Table
-- ================================

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);


-- ================================
-- 2. Create Products Table
-- ================================

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


-- ================================
-- 3. Create Orders Table
-- ================================

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);


-- ================================
-- 4. Create OrderDetails Table
-- ================================

CREATE TABLE OrderDetails (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_orderdetails_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT fk_orderdetails_product
    FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);
Check Table Creation Order
You must execute in this order:

1. Customers
        ↓
2. Products
        ↓
3. Orders
        ↓
4. OrderDetails
because:

Orders.customer_id
        ↓
Customers.customer_id


OrderDetails.order_id
        ↓
Orders.order_id


OrderDetails.product_id
        ↓
Products.product_id
The parent table must exist before creating the foreign key.

If Tables Already Exist
Drop them first:

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
Then execute the corrected script.

Verify Foreign Keys
After creation:

SHOW CREATE TABLE Orders;
You should see:

FOREIGN KEY (`customer_id`)
REFERENCES `Customers` (`customer_id`)
and no Error 3780.

Your corrected schema will now support your SalesDB analysis queries:

Monthly revenue trends

Customer revenue analysis

Product performance

Order volume analysis

Category sales analysis.


write a query as MYsql

For MySQL Workbench, use the following corrected SQL script. This version fixes the Error Code: 3780 by ensuring all primary key and foreign key columns have the same datatype (INT).

-- ===================================
-- Drop Existing Tables (if required)
-- ===================================

DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;


-- ===================================
-- 1. Create Customers Table
-- ===================================

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);


-- ===================================
-- 2. Create Products Table
-- ===================================

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


-- ===================================
-- 3. Create Orders Table
-- ===================================

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);


-- ===================================
-- 4. Create OrderDetails Table
-- ===================================

CREATE TABLE OrderDetails (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_orderdetails_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    CONSTRAINT fk_orderdetails_product
    FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);
Verify tables:
SHOW TABLES;
Check Orders foreign key:
SHOW CREATE TABLE Orders;
Expected output:

CONSTRAINT `fk_orders_customer`
FOREIGN KEY (`customer_id`)
REFERENCES `Customers` (`customer_id`)
Test relationship:
Insert customer:

INSERT INTO Customers(customer_name, signup_date)
VALUES ('John Smith','2025-01-10');
Insert order:

INSERT INTO Orders(customer_id, order_date, order_time, amount)
VALUES (1,'2025-01-15','10:30:00',5000.00);
The order will insert successfully because:

Customers.customer_id  INT
          |
          |
Orders.customer_id     INT
Both columns now match, so Error 3780 is resolved.


How to check whether data has been uploaded or not as orderdetails table showing null values

If your OrderDetails table is showing NULL values, first check whether the data was actually imported into the table or whether the issue is with the query/JOIN.

Follow these checks in MySQL Workbench:

1. Check if OrderDetails table contains records
Run:

SELECT * 
FROM OrderDetails;
If data exists, you should see:
detail_id	order_id	product_id	quantity
1	101	5	2
2	102	3	1
If you see:
Empty set
then data has not been uploaded.

2. Check total number of rows uploaded
SELECT COUNT(*) AS total_records
FROM OrderDetails;
Example output:

total_records
500
If result is:

0
then your CSV import failed or table is empty.

3. Check first few records
SELECT *
FROM OrderDetails
LIMIT 10;
This helps verify imported values.

4. Check table structure
Make sure column names match your CSV:

DESC OrderDetails;
Expected:

Field	Type
detail_id	INT
order_id	INT
product_id	INT
quantity	INT
5. If you imported CSV, check import success
Run:

SHOW WARNINGS;
after import.

Also check:

SELECT COUNT(*) 
FROM Orders;

SELECT COUNT(*) 
FROM Products;

SELECT COUNT(*) 
FROM Customers;

SELECT COUNT(*) 
FROM OrderDetails;
Example:

Table	Records
Customers	100
Products	50
Orders	500
OrderDetails	0 ❌
This indicates only OrderDetails failed.

6. Check if NULL values exist
Run:

SELECT 
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id_filled,
    COUNT(product_id) AS product_id_filled,
    COUNT(quantity) AS quantity_filled
FROM OrderDetails;
Example:

total_rows	order_id_filled	product_id_filled	quantity_filled
500	500	500	500
If you get:

total_rows	order_id_filled
500	0
then your columns were imported as NULL.

7. Check CSV import mapping
During MySQL Workbench import:

Go to:

Schemas
 → Tables
 → Right click OrderDetails
 → Table Data Import Wizard
Verify mapping:

CSV Column → Database Column

Example:

order_id      → order_id
product_id    → product_id
quantity      → quantity
8. Check Foreign Key mismatch
Because your table has:

FOREIGN KEY (order_id) REFERENCES Orders(order_id)
FOREIGN KEY (product_id) REFERENCES Products(product_id)
verify that matching IDs exist:

Check Order IDs:
SELECT order_id
FROM Orders
LIMIT 10;
Check OrderDetails IDs:
SELECT order_id
FROM OrderDetails
LIMIT 10;
If OrderDetails has order IDs that do not exist in Orders, inserts may fail.

9. Test with a manual insert
Try:

INSERT INTO OrderDetails
(order_id, product_id, quantity)
VALUES
(1,1,5);
Then:

SELECT * 
FROM OrderDetails;
If this works, your table structure is correct and the issue is only CSV import.

Most likely in your case (based on your previous Error 3780 issue), the table structure is fixed but the CSV import into OrderDetails did not map correctly. Run:

SELECT COUNT(*) FROM OrderDetails;
and share the result/error message if it is not loading.


Act as an experienced SQL Data Analyst.

I have a Sales Database containing the following tables:

1. customers
   - customer_id
   - customer_name
   - other customer details

2. orders
   - order_id
   - customer_id
   - order_date

3. orderdetails
   - order_id
   - product_id
   - quantity
   - price / sales amount

4. products
   - product_id
   - product_name
   - category
   - cost

Generate SQL queries based on the business requirements provided in my SalesDB Questions document.

For every query:

1. Write the business requirement/question first in professional business language.

2. Write the SQL query using appropriate:
   - INNER JOIN / LEFT JOIN wherever required
   - Aggregate functions
   - GROUP BY
   - ORDER BY
   - WHERE filters
   - HAVING conditions

3. Ensure the queries cover the following SQL analytics requirements:

A. Monthly Sales Trend Analysis
- Extract month from order_date using:
  EXTRACT(MONTH FROM order_date)
- Extract year using:
  EXTRACT(YEAR FROM order_date)
- Group sales by year and month:
  GROUP BY year, month
- Calculate total revenue using:
  SUM(quantity * price)
- Calculate order volume using:
  COUNT(DISTINCT order_id)
- Sort results chronologically using:
  ORDER BY year, month


B. Time Period Analysis
Create queries that allow filtering specific periods:
- Last 6 months sales performance
- Specific quarter analysis
- Specific year analysis

Use:
WHERE order_date BETWEEN start_date AND end_date

or appropriate date filtering functions depending on SQL database.


C. Revenue Analysis
Generate queries for:
- Total revenue by product category
- Revenue contribution by customer
- Monthly revenue trend
- Year-to-date revenue comparison

Use:
SUM(revenue)


D. Order Volume Analysis
Generate queries for:
- Number of unique orders
- Orders per customer
- Monthly order volume

Use:
COUNT(DISTINCT order_id)


E. Ranking Analysis
Create queries using:
ORDER BY DESC

for:
- Top 5 products by quantity sold
- Top 10 customers by revenue
- Highest revenue category
- Peak sales month


F. Limiting Results
Use:
LIMIT

for:
- Top 5 products
- Top 10 customers
- Bottom 10 products


G. Advanced Business Questions
Create SQL queries for:

1. Products never ordered
2. Customers who ordered previously but not in the last year
3. Top 3 products by profit margin:
   Profit = Revenue - Cost
4. Bottom 10% products by sales quantity
5. Category comparison using year-to-date revenue


Output Format:

For each query provide:

Business Requirement:
(Professional business question)

SQL Query:
(MySQL/PostgreSQL compatible query)

Explanation:
(Explain JOIN, aggregation, filtering, GROUP BY, ORDER BY usage)

Expected Output Columns:
(example: Year, Month, Revenue, Order Volume)


Make sure all queries are suitable for a Data Analyst portfolio project and GitHub documentation.

I will generate the complete MySQL-compatible SalesDB SQL Analysis Script based on your business requirements.

I have aligned the queries with your uploaded SalesDB Questions document, which includes requirements such as:

Revenue by product category

Top-selling products

Customers with multiple orders

Monthly sales trends

Customer revenue contribution

Q3 2025 category analysis

Profit analysis

Customer retention

Slow-moving products

Executive sales summary

 


Assumption: Your MySQL database schema:

customers
-----------
customer_id
customer_name
signup_date


orders
-----------
order_id
customer_id
order_date
order_time
amount


orderdetails
-----------
detail_id
order_id
product_id
quantity
price


products
-----------
product_id
product_name
product_category
price
cost
SalesDB SQL Analysis Portfolio Project
1. Revenue Analysis by Product Category
Business Requirement:
The category management team requires a report showing total revenue generated by each product category to evaluate category performance.

SQL Query:
SELECT
    p.product_category,
    SUM(od.quantity * od.price) AS total_revenue
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;
Explanation:
INNER JOIN combines product information with sales transactions.

SUM() calculates total revenue.

GROUP BY creates category-level aggregation.

ORDER BY ranks highest revenue categories first.

Expected Output:
product_category	total_revenue
Electronics	500000
Appliances	300000
2. Top 5 Products by Quantity Sold
Business Requirement:
The merchandising team wants to identify the top-performing products based on sales quantity.

SQL Query:
SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;
Explanation:
SUM(quantity) calculates units sold.

ORDER BY DESC ranks products.

LIMIT returns only top 5 products.

Expected Output:
Product	Quantity
Laptop	800
Mobile	650
3. Customers With More Than 5 Orders
Business Requirement:
The customer relationship team wants to identify loyal customers eligible for rewards.

SQL Query:
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 5
ORDER BY total_orders DESC;
Explanation:
COUNT(DISTINCT order_id) avoids duplicate counting.

HAVING filters aggregated results.

Expected Output:
Customer	Orders
John Smith	8
4. Monthly Sales Trend Analysis
Business Requirement:
The finance team wants a monthly sales performance report showing revenue and order volume trends.

SQL Query:
SELECT

EXTRACT(YEAR FROM o.order_date) AS sales_year,

EXTRACT(MONTH FROM o.order_date) AS sales_month,

SUM(od.quantity * od.price) AS revenue,

COUNT(DISTINCT o.order_id) AS order_volume

FROM Orders o

INNER JOIN OrderDetails od
ON o.order_id = od.order_id

GROUP BY

EXTRACT(YEAR FROM o.order_date),

EXTRACT(MONTH FROM o.order_date)

ORDER BY

sales_year,

sales_month;
Explanation:
EXTRACT() retrieves year and month.

GROUP BY creates monthly sales aggregation.

SUM calculates revenue.

COUNT DISTINCT calculates order volume.

Expected Output:
Year	Month	Revenue	Order Volume
2025	1	45000	120
5. Last 6 Months Sales Performance
Business Requirement:
Finance leadership wants to analyze recent six-month sales performance.

SQL Query:
SELECT

EXTRACT(YEAR FROM o.order_date) AS year,

EXTRACT(MONTH FROM o.order_date) AS month,

SUM(od.quantity * od.price) AS revenue,

COUNT(DISTINCT o.order_id) AS total_orders

FROM Orders o

JOIN OrderDetails od
ON o.order_id = od.order_id

WHERE o.order_date >= 
DATE_SUB(CURDATE(), INTERVAL 6 MONTH)

GROUP BY year, month

ORDER BY year, month;
Expected Output:
Year	Month	Revenue	Orders
6. Quarter Sales Analysis
Business Requirement:
The marketing team wants to analyze sales performance for a specific quarter.

SQL Query:
SELECT

QUARTER(o.order_date) AS quarter,

SUM(od.quantity * od.price) AS revenue

FROM Orders o

JOIN OrderDetails od

ON o.order_id = od.order_id

WHERE o.order_date BETWEEN 
'2025-07-01' AND '2025-09-30'

GROUP BY QUARTER(o.order_date);
7. Revenue Contribution by Top 10 Customers
Business Requirement:
The sales team wants to identify customers contributing the highest revenue.

SQL Query:
SELECT

c.customer_name,

SUM(od.quantity * od.price) AS customer_revenue

FROM Customers c

JOIN Orders o
ON c.customer_id=o.customer_id

JOIN OrderDetails od
ON o.order_id=od.order_id

GROUP BY c.customer_name

ORDER BY customer_revenue DESC

LIMIT 10;
Expected Output:
Customer	Revenue
8. Highest Revenue Category
Business Requirement:
Management wants to identify the category generating maximum revenue.

SQL Query:
SELECT

p.product_category,

SUM(od.quantity * od.price) AS revenue

FROM Products p

JOIN OrderDetails od
ON p.product_id=od.product_id

GROUP BY p.product_category

ORDER BY revenue DESC

LIMIT 1;
9. Monthly Order Volume Analysis
Business Requirement:
Operations team wants to monitor monthly order activity.

SQL Query:
SELECT

YEAR(order_date) AS year,

MONTH(order_date) AS month,

COUNT(DISTINCT order_id) AS order_volume

FROM Orders

GROUP BY

YEAR(order_date),

MONTH(order_date)

ORDER BY year, month;
10. Products Never Ordered
Business Requirement:
Inventory team wants to identify products that have never been sold.

SQL Query:
SELECT

p.product_id,

p.product_name

FROM Products p

LEFT JOIN OrderDetails od

ON p.product_id = od.product_id

WHERE od.product_id IS NULL;
Explanation:
LEFT JOIN keeps all products and finds missing sales records.

11. Customers Who Purchased Previously But Not Last Year
Business Requirement:
Customer retention team wants inactive customers who have not purchased in the last year.

SQL Query:
SELECT

c.customer_id,

c.customer_name,

MAX(o.order_date) AS last_purchase_date

FROM Customers c

JOIN Orders o

ON c.customer_id=o.customer_id

GROUP BY

c.customer_id,

c.customer_name

HAVING MAX(o.order_date) <
DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
12. Top 3 Products by Profit
Business Requirement:
Management wants to identify products generating the highest profit.

Profit Formula:

Profit = Revenue - Cost
SQL Query:
SELECT

p.product_name,

SUM(od.quantity * od.price)
-
SUM(od.quantity * p.cost) AS profit

FROM Products p

JOIN OrderDetails od

ON p.product_id=od.product_id

GROUP BY p.product_name

ORDER BY profit DESC

LIMIT 3;
13. Bottom 10 Products by Sales Quantity
Business Requirement:
Inventory team wants to identify slow-moving products.

SQL Query:
SELECT

p.product_name,

SUM(od.quantity) AS total_quantity

FROM Products p

JOIN OrderDetails od

ON p.product_id=od.product_id

GROUP BY p.product_name

ORDER BY total_quantity ASC

LIMIT 10;
14. Year-To-Date Revenue by Category
Business Requirement:
The board wants a comparison of current year revenue contribution across product categories.

SQL Query:
SELECT

p.product_category,

SUM(od.quantity * od.price) AS ytd_revenue

FROM Products p

JOIN OrderDetails od

ON p.product_id=od.product_id

JOIN Orders o

ON od.order_id=o.order_id

WHERE YEAR(o.order_date)=YEAR(CURDATE())

GROUP BY p.product_category

ORDER BY ytd_revenue DESC;
15. Peak Sales Month
Business Requirement:
The strategy team wants to identify the highest-performing sales month.

SQL Query:
SELECT

YEAR(o.order_date) AS year,

MONTH(o.order_date) AS month,

SUM(od.quantity * od.price) AS revenue

FROM Orders o

JOIN OrderDetails od

ON o.order_id=od.order_id

GROUP BY

YEAR(o.order_date),

MONTH(o.order_date)

ORDER BY revenue DESC

LIMIT 1;
SQL Concepts Covered
Requirement	SQL Function
Monthly Trend	EXTRACT(), GROUP BY
Revenue Calculation	SUM(quantity*price)
Order Volume	COUNT(DISTINCT order_id)
Ranking	ORDER BY DESC
Top Results	LIMIT
Filtering Periods	WHERE BETWEEN
Customer Analysis	JOIN
Missing Products	LEFT JOIN
Profit Analysis	Revenue-Cost
Business Reporting	Aggregations
This script is suitable for a Data Analyst SQL portfolio project and GitHub README documentation.


fix the error code 1054 :unknown column od.price in column list for SQL query no 1

The error:

Error Code: 1054. Unknown column 'od.price' in 'field list'
means your OrderDetails table does not have a column named price.

In the previous query:

SUM(od.quantity * od.price) AS total_revenue
MySQL is looking for:

OrderDetails.price
but your actual table structure is different.

Step 1: Check your OrderDetails columns
Run:

DESC OrderDetails;
You will probably see something like:

detail_id
order_id
product_id
quantity
(no price column)

Fix Query No.1 Based on Your Current Schema
Your Products table contains:

product_id
product_name
product_category
price
So use Products.price instead of OrderDetails.price.

Correct Query:
SELECT
    p.product_category,
    SUM(od.quantity * p.price) AS total_revenue
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;
Explanation:
Products p contains product selling price.

OrderDetails od contains quantity sold.

Revenue calculation:

quantity × product price
Example:

Laptop price = 50000
Quantity sold = 10

Revenue = 50000 × 10 = 500000
GROUP BY p.product_category calculates category-wise revenue.

ORDER BY total_revenue DESC shows highest revenue categories first.

Expected Output:
product_category	total_revenue
Electronics	750000
Appliances	450000
Furniture	250000
Alternative Fix (Recommended for Sales Analysis)
For real-world sales databases, the price at the time of purchase should be stored in OrderDetails.

Your ideal table should be:

CREATE TABLE OrderDetails (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
Then your original query works:

SUM(od.quantity * od.price)
because order history keeps the actual selling price.

For your current database, use:

SUM(od.quantity * p.price)
for all revenue-related queries:

✅ Query 1 Revenue by Category
✅ Query 4 Monthly Sales Trend
✅ Query 6 Customer Revenue
✅ Query 12 Profit Analysis
✅ Query 14 YTD Revenue

You only need to replace:

od.price
with:

p.price
in those queries.


create queries as per the create tables and datasets

Based on your actual MySQL CREATE TABLE structure, the queries should be written using these columns:

Database Schema (Your Created Tables)
Customers
-----------
customer_id
customer_name
signup_date


Products
-----------
product_id
product_name
product_category
price


Orders
-----------
order_id
customer_id
order_date
order_time
amount


OrderDetails
-----------
detail_id
order_id
product_id
quantity
Important correction:
Your OrderDetails table does not contain price, so revenue must be calculated as:

quantity * Products.price
not:

quantity * OrderDetails.price
SalesDB SQL Analysis Queries (MySQL Compatible)
1. Total Revenue by Product Category
Business Requirement:
The category management team wants to analyze revenue performance by product category.

SQL Query:
SELECT
    p.product_category,
    SUM(od.quantity * p.price) AS total_revenue
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;
Explanation:
JOIN combines products and sales details.

SUM calculates revenue.

GROUP BY provides category-level analysis.

Output:
product_category	total_revenue
Electronics	500000
2. Top 5 Products by Quantity Sold
Business Requirement:
The merchandising team wants to identify the best-selling products.

SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;
3. Customers With More Than 5 Orders
Business Requirement:
The customer loyalty team wants customers eligible for rewards.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM Customers c
INNER JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id)>5
ORDER BY total_orders DESC;
4. Monthly Sales Trend Analysis
Business Requirement:
Finance wants monthly revenue and order volume trends.

SELECT

YEAR(o.order_date) AS sales_year,

MONTH(o.order_date) AS sales_month,

SUM(od.quantity * p.price) AS revenue,

COUNT(DISTINCT o.order_id) AS order_volume

FROM Orders o

INNER JOIN OrderDetails od
ON o.order_id=od.order_id

INNER JOIN Products p
ON od.product_id=p.product_id


GROUP BY

YEAR(o.order_date),

MONTH(o.order_date)

ORDER BY

sales_year,

sales_month;
5. Last 6 Months Sales Performance
Business Requirement:
Management wants recent sales performance analysis.

SELECT

YEAR(o.order_date) AS year,

MONTH(o.order_date) AS month,

SUM(od.quantity*p.price) AS revenue,

COUNT(DISTINCT o.order_id) AS orders

FROM Orders o

JOIN OrderDetails od
ON o.order_id=od.order_id

JOIN Products p
ON od.product_id=p.product_id

WHERE o.order_date >= DATE_SUB(CURDATE(),INTERVAL 6 MONTH)

GROUP BY

YEAR(o.order_date),

MONTH(o.order_date)

ORDER BY year,month;

# 6. Revenue Contribution by Top 10 Customers
# Business Requirement: Sales leadership wants customers contributing the highest revenue.

SELECT

c.customer_name,

SUM(od.quantity*p.price) AS customer_revenue

FROM Customers c

JOIN Orders o
ON c.customer_id=o.customer_id

JOIN OrderDetails od
ON o.order_id=od.order_id

JOIN Products p
ON od.product_id=p.product_id

GROUP BY c.customer_name

ORDER BY customer_revenue DESC

LIMIT 10;
# 7. Highest Revenue Product Category
# Business Requirement: Management wants to identify the highest revenue-generating category.

SELECT

p.product_category,

SUM(od.quantity*p.price) AS revenue

FROM Products p

JOIN OrderDetails od
ON p.product_id=od.product_id

GROUP BY p.product_category

ORDER BY revenue DESC

LIMIT 1;

# 8. Average Order Value by Customer
# Business Requirement: Business analysts want to measure customer spending value.

SELECT

c.customer_name,

ROUND(AVG(o.amount),2) AS average_order_value

FROM Customers c

JOIN Orders o
ON c.customer_id=o.customer_id

GROUP BY c.customer_name

ORDER BY average_order_value DESC;

#9. Products Never Ordered
#Business Requirement: Inventory team wants products that have no sales history.

SELECT

p.product_id,

p.product_name

FROM Products p

LEFT JOIN OrderDetails od

ON p.product_id=od.product_id

WHERE od.product_id IS NULL;

# 10. Customers Who Did Not Purchase in Last Year
# Business Requirement: Retention team wants inactive customers.

SELECT
c.customer_id,
c.customer_name,
MAX(o.order_date) AS last_purchase_date
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY
c.customer_id,
c.customer_name
HAVING MAX(o.order_date) < 
DATE_SUB(CURDATE(),INTERVAL 1 YEAR);

# 11. Top 3 Products by Profit
# Business Requirement:- Management wants products generating highest profit.

# Note: Your Products table currently does not contain cost column.
# Add it first:

ALTER TABLE Products
ADD cost DECIMAL(10,2);

SELECT
p.product_name,
SUM(od.quantity*p.price)
-SUM(od.quantity*p.cost) AS profit
FROM Products p
JOIN OrderDetails od
ON p.product_id=od.product_id
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 3;

#12. Bottom 10 Products by Quantity Sold
#Business Requirement: Inventory team wants slow-moving products.

SELECT
p.product_name,
SUM(od.quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od
ON p.product_id=od.product_id
GROUP BY p.product_name
ORDER BY total_quantity ASC
LIMIT 10;

#13. Year-to-Date Revenue by Category
#Business Requirement: Management wants current year category revenue comparison.
SELECT
    p.product_category,
    SUM(od.quantity * p.price) AS ytd_revenue
FROM Products p
INNER JOIN OrderDetails od
ON p.product_id = od.product_id
INNER JOIN Orders o
ON od.order_id = o.order_id
WHERE YEAR(o.order_date) =
(
SELECT MAX(YEAR(order_date))
    FROM Orders
)
GROUP BY p.product_category
ORDER BY ytd_revenue DESC;

#14. Peak Sales Month
#Business Requirement: Strategy team wants the highest sales month.
SELECT
YEAR(o.order_date) AS year,
MONTH(o.order_date) AS month,
SUM(od.quantity*p.price) AS revenue
FROM Orders o
JOIN OrderDetails od
ON o.order_id=od.order_id
JOIN Products p
ON od.product_id=p.product_id
GROUP BY
YEAR(o.order_date),
MONTH(o.order_date)
ORDER BY revenue DESC
LIMIT 1;