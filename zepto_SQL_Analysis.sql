drop table if exists zepto;

create table zepto(
sku_id SERIAL primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);


select count(*) from zepto;

select * from zepto
limit 10;

--check null values

select * from zepto
where name is null
or 
name is null
or 
category is null
or 
mrp is null
or 
discountPercent is null
or 
discountedSellingPrice is null
or 
weightInGms is null
or 
availableQuantity is null
or 
outOfStock is null
or 
quantity is null;

--different product categories
select distinct category
from zepto
order by category;

--product in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "number of skus"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

--data cleaning

--products with prices with 0
select * 
from zepto
where mrp = 0 
or discountedSellingPrice = 0;

delete from zepto where mrp = 0;

--conversion of paise to rupees
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

--Top 10 best-value products based on the discounted percentage
select distinct name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

--ANALYSIS: this is useful for both customers looking for bargain and businesses to know which products are heavily promoted


--products with high mrp but out of stock
select distinct name, mrp
from zepto
where outOfStock = true and mrp > 300
order by mrp desc;

--ANALYSIS: these are high priced products and the company might want to restock them as the customers are buying them frequently

--estimated revenue for each category
select category, sum(discountedSellingPrice * availableQuantity) as Total_revenue
from zepto
group by category
order by Total_revenue;

--products where mrp is greater than Rs. 500 and discount is less than 10%
select distinct name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--ANALYSIS: the reason that these products don't have discounts is that these products are popular enough 
------------and already sell well without any discounts needed

--top 5 categories offering highest average discount percentage
select category, round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--ANALYSIS: this analysis can be used by the marketing teams where price cuts are happening the most and how to optimize them accordingly

--price per gram for products above 100gms and sort by best values
select distinct name, weightInGms, discountedSellingPrice, round(discountedSellingPrice/weightInGms,2) as Price_per_gram
from zepto
where weightInGms >= 100
order by Price_per_gram;

--ANALYSIS: helpful for customers to compare value for money products and even for internal pricing strategies

--grouping of products into categories like low, medium, Bulk
select distinct name, weightInGms, 
case when weightInGms < 1000 then 'low'
	when weightInGms < 5000 then 'Medium'
	else 'Bulk'
	end as Weight_category
from zepto;

--ANALYSIS: this segmentation is useful for packaging, delivery planning and bulk order strategies

--total inventory weight per category
select category, sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;

--ANALYSIS: useful for warehouse planning, or identify bulky product categories
