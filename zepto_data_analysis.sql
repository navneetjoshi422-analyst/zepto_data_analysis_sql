drop table if exists data_zepto;
create table data_zepto(
sku_id Serial Primary key,
Category varchar(150),
name varchar(150) not null,
mrp Numeric(8,2),
discountPercent Numeric(5,2),
availableQuantity integer,
discountedSellingPrice Numeric(8,2),
weightInGms integer,
outOfStock Boolean,
quantity integer
);
-- sample data

select * from data_zepto limit 10;

-- data exploration

select count(*) from data_zepto;

-- find null values

select * from data_zepto
where Category is null 
or name is null 	
or mrp	is null 
or discountPercent is null 
or availableQuantity is null 
or discountedSellingPrice is null 
or weightInGms is null 
or outOfStock is null 
or quantity is null ;

-- different product categories

select distinct category from
data_zepto
order by category;

-- products in stock vs products out of stock

select outofstock,count(sku_id) 
from data_zepto
group by outofstock
;

-- products name present multiple times

select name ,count(name) as nc from data_zepto
group by name
having count(name)>1
order by nc desc;

-- data cleaning

-- products with price = 0
select * from data_zepto
where mrp = 0 or discountedSellingPrice = 0;

delete from data_zepto 
where mrp = 0;

-- update paisa into rupee 
update data_zepto
set mrp = mrp/100.00,
discountedSellingPrice = discountedSellingPrice/100.00;

select mrp,discountedSellingPrice from data_zepto;

-- business questions
-- Q1. Find the top 10 best-value products based on the discount percentage.
select * from data_zepto;
select distinct name ,mrp ,discountpercent from data_zepto
order by discountpercent desc limit 10;

--Q2.What are the Products with High MRP but Out of Stock

select distinct name ,mrp from data_zepto
where outofstock='true'and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category

select category , sum(discountedSellingPrice*availablequantity) as total_revenue from 
data_zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

select distinct name , mrp , discountpercent from data_zepto
where mrp>500 and discountpercent<10
order by mrp desc ,discountpercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select category , round(avg(discountpercent),2) as avg_discount from 
data_zepto
group by category
order by avg_discount desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM data_zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

select distinct name,weightingms,
case when weightingms<1000 then 'low'
when weightingms<5000 then 'high'
else 'bulk'
end as weight_category
from data_zepto;

--Q8.What is the Total Inventory Weight Per Category.

select category,sum(availablequantity*weightingms) as Weight_Per_Category
from data_zepto
group by category
ORDER BY Weight_Per_Category;