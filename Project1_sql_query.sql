-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
	age is null
	or
    total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
	age is null
	or
    total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- which category are there ?
SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales 
where 
	category ='Clothing'
	and
	quantity >= 4
	and sale_date between '2022-11-1' and '2022-11-30'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category , 
	sum(total_sale) as net_sale,
	count(*) as total_order
from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select distinct(category) from retail_sales
select distinct(category) from retail_sales

-- for both gender and category
select category,gender,count(transaction_id) as total_transactions  
from retail_sales
group by category , gender
order by 1

-- for category
select count(transaction_id) as total_transactions , category
from retail_sales
group by category 

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from retail_sales

select 
	year,
	month,
	avg_sale from
(select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date)  order by avg(total_sale) desc ) as rank
from retail_sales
group by 1,2
order by 1,3 desc) as t1
where rank =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id ,
	sum(total_sale) as customer_sale
from 
	retail_sales
group by 
	customer_id -- 1
order by 
	2 desc -- customer_sale desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select * from retail_sales

select category , count(distinct(customer_id)) as unique_customer
from retail_sales
group by 1
order by 1 asc

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select * from retail_sales


with hourly_sale
as
(select *,
	case
	 	when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales)
select shift ,
	count(*)
	from hourly_sale
	group by shift

-- End of Project