**📊 SalesDB SQL Analysis Project
📌 Project Overview**

This project focuses on analyzing sales transaction data using SQL (MySQL) to generate business insights related to revenue performance, customer behavior, product performance, and sales trends.

The objective of this project is to demonstrate practical Data Analyst SQL skills including:

Data querying
Joins
Aggregations
Filtering
Time-based analysis
Ranking analysis
Business reporting

The analysis is performed on a relational sales database containing customers, products, orders, and order details.

🗂️ Database Schema

**The project uses the following tables:**

Customers Table
Column	        -                                   Description
customer_id	    -                                   Unique customer identifier
customer_name	-                                   Customer name
signup_date	    -                                   Customer registration date

Products Table
Column	                                       Description
product_id	                                   Unique product identifier
product_name	                               Product name
product_category	                           Product category
price	                                       Selling price
cost	                                           Product cost

Orders Table
Column	                                         Description
order_id	                                       Unique order identifier
customer_id	                                     Customer reference
order_date	                                     Order purchase date
order_time	                                     Order purchase time
amount	                                         Order amount

OrderDetails Table
Column	                                         Description
detail_id	                                       Transaction detail ID
order_id	                                       Order reference
product_id	                                     Product reference
quantity	                                       Number of products purchased

**🛠️ Tools & Technologies**
Tool	                                           Purpose
MySQL	                                           Database Management
MySQL Workbench	                                 Query Execution
SQL	                                             Data Analysis
GitHub	                                         Project Documentation


**🎯 Business Objectives**

The project answers key business questions:
Which product categories generate the highest revenue?
Which products are best sellers?
Who are the most valuable customers?
How does revenue change month-to-month?
Which products are slow-moving?
Which categories contribute most to yearly revenue?
Which products generate maximum profit?

**📈 SQL Analysis Performed**
1. Revenue Analysis by Product Category
Business Question:

Which product categories generate the highest revenue?

SQL Concepts Used:
INNER JOIN
SUM()
GROUP BY
ORDER BY DESC
Business Insight:

Identifies high-performing categories to support inventory and marketing decisions.

2. Top 5 Products by Quantity Sold
Business Question:

What are the top-selling products based on sales quantity?

SQL Concepts Used:
Aggregate functions
Ranking
LIMIT
Business Insight:

Helps identify products driving sales volume.

3. Customer Loyalty Analysis
Business Question:

Which customers have placed more than five orders?

SQL Concepts Used:
COUNT(DISTINCT)
GROUP BY
HAVING
Business Insight:

Identifies repeat customers for loyalty programs.

4. Monthly Sales Trend Analysis
Business Question:

How does revenue and order volume change monthly?

SQL Concepts Used:
YEAR()
MONTH()
SUM()
COUNT(DISTINCT order_id)
Metrics Generated:
Monthly Revenue
Monthly Order Volume
Business Insight:

Helps understand sales patterns and seasonal trends.

5. Last 6 Months Sales Performance
Business Question:

What is the recent sales performance trend?

SQL Concepts Used:
Date filtering
DATE_SUB()
Aggregation
Business Insight:

Supports short-term sales forecasting.

6. Quarter Sales Analysis
Business Question:

What was the sales performance during a specific quarter?

SQL Concepts Used:
BETWEEN
QUARTER()
GROUP BY
Business Insight:

Helps evaluate quarterly business performance.

7. Customer Revenue Contribution
Business Question:

Which customers contribute the highest revenue?

SQL Concepts Used:
Multiple JOINs
SUM()
ORDER BY DESC
LIMIT
Business Insight:

Identifies high-value customers.

8. Highest Revenue Category
Business Question:

Which category generates maximum revenue?

SQL Concepts Used:
Aggregation
Sorting
LIMIT
Business Insight:

Supports category-level strategy decisions.

9. Monthly Order Volume Analysis
Business Question:

How many orders are generated each month?

SQL Concepts Used:
COUNT(DISTINCT order_id)
GROUP BY date
Business Insight:

Measures customer purchasing activity.

10. Products Never Ordered
Business Question:

Which products have no sales history?

SQL Concepts Used:
LEFT JOIN
NULL filtering
Business Insight:

Helps identify products requiring promotion or removal.

11. Top 3 Products by Profit
Business Question:

Which products generate the highest profit?

Formula:
Profit = Revenue - Cost
SQL Concepts Used:
SUM()
Calculation columns
ORDER BY DESC
LIMIT
Business Insight:

Identifies profitable products.

12. Bottom 10 Slow Moving Products
Business Question:

Which products have the lowest sales quantity?

SQL Concepts Used:
SUM()
ORDER BY ASC
LIMIT
Business Insight:

Supports inventory optimization.

13. Year-to-Date Revenue by Category
Business Question:

How much revenue has each category generated in the current sales year?

SQL Concepts Used:
YEAR()
SUM()
GROUP BY
Business Insight:

Provides yearly category performance comparison.

14. Peak Sales Month Analysis
Business Question:

Which month achieved the highest revenue?

SQL Concepts Used:
Date aggregation
ORDER BY DESC
LIMIT
Business Insight:

Identifies peak sales periods.

**📊 Key SQL Skills Demonstrated**

✅ SELECT statements
✅ INNER JOIN
✅ LEFT JOIN
✅ Aggregate Functions

SUM()
COUNT()
AVG()

✅ Filtering

WHERE
HAVING
BETWEEN

✅ Time Analysis

YEAR()
MONTH()
DATE_SUB()

✅ Ranking

ORDER BY DESC
LIMIT
📁 Project Structure
SalesDB-SQL-Analysis
│
├── README.md
│
├── database
│   └── salesdb_schema.sql
│
├── sql_queries
│   └── sales_analysis_queries.sql
│
├── data
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── orderdetails.csv
│
└── output
    └── analysis_results.xlsx
**🚀 How to Run Project**
Step 1: Create Database
CREATE DATABASE SalesDB;
Step 2: Import Tables

Execute:

salesdb_schema.sql
Step 3: Load Dataset

Import:

Customers
Products
Orders
OrderDetails
Step 4: Execute Analysis Queries

Run:

sales_analysis_queries.sql
**📌 Business Impact**

This SQL analysis helps organizations:

Improve product strategy
Identify profitable categories
Understand customer purchasing behavior
Optimize inventory
Monitor revenue growth
Support data-driven decisions
**👩‍💻 Author**

Madhulata Mukkamala

Data Analyst Portfolio Project

Skills Demonstrated:

SQL
MySQL
Data Analysis
Business Intelligence
Reporting
⭐ Project Highlights

This project demonstrates how SQL can transform raw transactional data into meaningful business insights using real-world analytical requirements.
