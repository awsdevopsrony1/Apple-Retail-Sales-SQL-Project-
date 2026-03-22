select * from category;
select * from products;
select * from sales;
select * from stores;
select * from warranty;
---------------------------------------------------------------
-- Basic Level (1–6)
-- 1 Show all products
select * from products;
-- 2 Show product name and price
select product_Name,Price
from products;
-- 3 Find all stores in USA
select * from stores;
select *
from stores
where Country='United States';

-- 4  Count total number of products
select * from products;
select count(*) as total_count;
-- 5 Find distinct cities where stores are located
select * from stores;
select distinct(city)
from stores;
-- 6  Get products with price greater than 1000
select * from products;

select *
from products
where price>1000;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Intermediate Level (7–13)
-- 7) Total sales quantity
select * from sales;
select sum(quantity) as total_quantity;
-- 8 Total sales per product
select product_id, sum(quantity) as total_sales
from sales
group by product_id;
-- 9  Join products with categories
select * from category;
select * from products;
select p.product_Name,c.category_name
from products p join category c 
on p.Category_ID=c.category_id;

-- 10 Total revenue per product
select * from products;
select * from sales;
select p.product_Name,sum(p.price * s.quantity)as total_rvne
from products p join sales s 
on p.Product_ID= s.product_id
group by p.Product_Name;
-- 11 Find number of stores per country
select * from stores;
select country,count(*) as total_count
from stores
group by Country;

-- 12 Get latest sale date
select * from sales;
select sale_date 
from sales
order by sale_date desc
limit 1;
-- Find products never sold
select * from products;
select * from sales;
select * 
from products p left join sales s 
on p.Product_ID=s.product_id;

-- Advanced Level (14–20)
-- 14 Top 5 best-selling products
select * from products;
select * from sales;
with cte1 as
(
select p.product_ID,p.product_NAME,SUM(s.quantity) as total_qunatity,
dense_rank()over(order by  sum(s.quantity) desc) as rn
from sales s join products p 
on s.product_id=p.Product_ID
group by p.product_ID,Product_Name
)
select *
from cte1
where rn <=5;
-- 15  Revenue by category
select * from products;
select * from sales;
select * FROM category;
select c.category_name,sum(p.price *s.quantity) as total_rvne
from sales s join products p 
on s.product_id=p.Product_ID
join category c 
on p.Category_ID=c.category_id
group by c.category_name;
-- 16 Store-wise sales performance
select * from stores;
select * from sales;
select st.store_Name,sum(s.quantity)as total_sales
from sales s join stores st 
on s.store_id=st.Store_ID
group by st.Store_Name;

-- 17  Monthly sales trend
select * from sales;

SELECT MONTH(sale_date) AS month,
       SUM(quantity) AS total_sales
FROM sales
GROUP BY MONTH(sale_date)
ORDER BY month;
-- 18  Products with highest revenue in each category
select * from products;
select * from category;
select * from sales;

WITH cte AS (
    SELECT c.category_name,
           p.Product_Name,
           SUM(s.quantity * p.Price) AS revenue,
           ROW_NUMBER() OVER(PARTITION BY c.category_name ORDER BY SUM(s.quantity * p.Price) DESC) rn
    FROM sales s
    JOIN products p ON s.product_id = p.Product_ID
    JOIN category c ON p.Category_ID = c.category_id
    GROUP BY c.category_name, p.Product_Name
)
SELECT *
FROM cte
WHERE rn = 1;
------------------------------------------------------------------------------------------------------------------------------------------------
-- WINDOW FUNCTION Questions (Advanced Level

-- 1)Rank products by total sales
SELECT p.Product_Name,
       SUM(s.quantity) AS total_sales,
       RANK() OVER(ORDER BY SUM(s.quantity) DESC) AS rank_
FROM sales s
JOIN products p ON s.product_id = p.Product_ID
GROUP BY p.Product_Name;
-- 2)  Row number for each sale per product
SELECT sale_id,
       product_id,
       quantity,
       ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY sale_date) AS rn
FROM sales;
-- 3) Get top-selling product in each category
WITH cte AS (
    SELECT c.category_name,
           p.Product_Name,
           SUM(s.quantity) AS total_sales,
           RANK() OVER(PARTITION BY c.category_name ORDER BY SUM(s.quantity) DESC) rnk
    FROM sales s
    JOIN products p ON s.product_id = p.Product_ID
    JOIN category c ON p.Category_ID = c.category_id
    GROUP BY c.category_name, p.Product_Name
)
SELECT *
FROM cte
WHERE rnk = 1;