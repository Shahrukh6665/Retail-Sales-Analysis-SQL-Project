-- SQL Retail Sales Analysis

-- CREATE DATABASE

CREATE DATABASE retail_db;

USE retail_db;

-- CREATE TABLE

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT 
    *
FROM
    retail_sales
LIMIT 10;

SELECT
	COUNT(*)
FROM retail_sales;

-- DATA CLEANING

SELECT 
	*
FROM 
retail_sales
WHERE transactions_id IS NULL;

SELECT 
	*
FROM 
retail_sales
WHERE sale_date IS NULL;

SELECT 
	*
FROM 
retail_sales
WHERE sale_time IS NULL;

SELECT 
	* 
FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE 
FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- DATA EXPLORATION

-- How many sales we have?

SELECT
	COUNT(*) AS "Total Sales"
FROM retail_sales;

-- How many unique customers we have?

SELECT
	COUNT(DISTINCT customer_id) AS "Unique Customers"
FROM retail_sales;

-- How many unique category we have?

SELECT 
	DISTINCT category
FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

/*
	Q1. Write a SQL query to retrieve all columns for sales
	    made on '2022-11-05'.
*/

SELECT
	*
FROM retail_sales
WHERE sale_date = '2022-11-5';

/* 
	Q2. Write a SQL query to retrieve all transactions where 
	the category is 'Clothing' and the quantity sold is more
	than 4 in the month of Nov-2022.
*/

SELECT 
    *
FROM
    retail_sales
WHERE
    (Category = 'Clothing' AND quantity >= 4)
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

/*
	Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
*/

SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY 
	category;
    
/*
	Q.4 Write a SQL query to find the average age of customers who purchased items from the
    'Beauty' category.
*/

SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';
    
/*
	Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
*/

SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
    
/*
	Q.6 Write a SQL query to find the total number of transactions (transaction_id) made
    by each gender in each category.
*/

SELECT 
    gender, 
    category, 
    COUNT(transactions_id) as total_trans
FROM
    retail_sales
GROUP BY 
	gender , category
order by
	total_trans;
    
/*
	Q.7 Write a SQL query to calculate the average sale for each month. Find out best 
    selling month in each year
*/

SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale
FROM
    retail_sales
GROUP BY 
	year , month
ORDER BY 
	avg_sale DESC;
    

SELECT
	year,
    month,
    avg_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH from sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranks
	FROM
		retail_sales
	GROUP BY
		year, month        
) AS t1
WHERE
	ranks = 1;
    
/*
	Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
*/

SELECT 
    customer_id, 
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY 
	customer_id
ORDER BY 
	total_sales DESC
LIMIT 5;

/*
	Q.9 Write a SQL query to find the number of unique customers who purchased items from 
    each category.
*/

SELECT 
    category, 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM
    retail_sales
GROUP BY 
	category;

/*
	Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, 
    Afternoon Between 12 & 17, Evening >17)
*/
WITH hourly_sale
AS
(
SELECT
	*,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_date) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
from
	retail_sales
 )   
 SELECT
	shift,
    count(*) as total_orders
FROM 
	hourly_sale
GROUP BY
	shift;