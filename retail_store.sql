-- 1. Understanding the Dataset 

-- Checking available Tables
select table_name from information_schema.tables
where table_schema = 'public';

-- Viewing Table Structure (Schema)
select column_name, data_type
from information_schema.columns
where table_name = 'online_retail';

-- Previewing the Dataset
select * from online_retail;





-- 2. Data Cleaning & handling Missing Values
-- Identify Missing values
select 
count(*) as total_rows,
count(invoice_no) as invoivce_numbers,
count(stock_code) as stock_code,
count(description) as description,
count(quantity) as quantity,
count(invoice_date) as invoice_date,
count(unit_price) as unit_price,
count(customer_id) as cust_id,
count(country) as country
from online_retail;

-- Removing Null Values
update online_retail
set description = coalesce(description, 'No Description'),
	customer_id = coalesce(customer_id, 0),
	country = coalesce(country, 'None');

-- Checking Null values 
select count(*) from online_retail where description is null;

-- Data Type Conversion
alter table online_retail
alter column invoice_date type timestamp
using to_timestamp(invoice_date, 'MM-DD-YYYY HH24:MI');






-- 3. Descriptive Analysis
-- Total Sales Revenue
select sum(quantity * unit_price) as total_revenue
from online_retail;

-- Top 5 Best-Selling Product
select description, sum(quantity) as total_quantity_sold
from online_retail
group by description
order by total_quantity_sold desc
limit 5;

-- Country wise Revenue Dstribution
select country, sum(quantity * unit_price) as total_revenue
from online_retail
group by country
order by total_revenue desc;

-- Most expensive products
select description, unit_price
from online_retail
order by unit_price desc
limit 5;

-- Customer Retention Analysis
select customer_id, count(distinct invoice_no) as purchase_count
from online_retail
group by customer_id
having count(distinct invoice_no) > 20
order by purchase_count desc;