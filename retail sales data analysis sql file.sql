-- creating a table
create table retail_sales
(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float

)

-- verifying created table
select * from retail_sales;

-- total entries in the table
select count(*) from retail_sales;

-------------------------------------------------------------------------------------------------------------------


-- Data cleaning

-- checking null entries in the table
select * from retail_sales
where
(transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null)
;

-- deleting the rows where there is not price values
delete from retail_sales
where
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;


-- treating age null values by average age values
select round(avg(age),0) as mean_age from retail_sales;

update retail_sales
set age = (select round(avg(age),0) from retail_sales)
where age is null;

Select count(*) from retail_sales;

-------------------------------------------------------------------------------------------------------------------


--Data exploration

--how many sales we have?
select count(*) as total_sales from retail_sales;

-- how many unique customers we have?
select count(distinct customer_id) as total_customer from retail_sales;

-- how many categories we have?
select distinct category as categories from retail_sales;

-------------------------------------------------------------------------------------------------------------------


-- Data analysis 

select * from retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';



-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 3 in the month of Nov-2022
select * from retail_sales where category = 'Clothing' and quantiy>=4 and to_char(sale_date,'YYYY-MM') = '2022-11';



-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as net_sale, count(*) as total_orders from retail_sales group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),0) as average_age_of_beauty_customers from retail_sales where category='Beauty';



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;



-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(*) as total_transactions, gender, category from retail_sales group by category, gender;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year, month, avg_sale
from
(select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
-- Ranks the average sales within each year ordering them in descending order
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales group by 1,2)
as t1
where rank=1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as total_sales from retail_sales group by 1 order by 2 desc limit 5;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as cnt_of_unique_customer from retail_sales group by 1;



-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_shifts
as
(
select *,
case
	when extract(hour from sale_time)<12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
	from retail_sales
)
select shift, count(*) as total_orders from hourly_shifts group by shift;

-----------------------------------------------------------------------------------------------------------------------

