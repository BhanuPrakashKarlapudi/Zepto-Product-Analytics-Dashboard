drop table if exists zepto;


create table zepto(
cetegory VARCHAR(120),
name VARCHAR(120),
mrp DECIMAL(10,2),
discountPercent DECIMAL(10,2),
availbleQuantity INT,
discountedSellingPrice DECIMAL(10,2),
weightInGms INT,
outOfStock BOOLEAN,
quantity INT
);

SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:\\ZEPTO PROJECT\\zepto_sales.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cetegory, name, mrp, discountPercent, availbleQuantity, discountedSellingPrice, weightInGms, @outOfStock, quantity)
SET outOfStock = IF(@outOfStock = 'TRUE', 1, 0);

SELECT * FROM zepto;

-- TABLE MODIFY
UPDATE zepto
SET discountedsellingprice = discountedsellingprice/100.0;

UPDATE zepto
SET mrp = mrp/100.0;


-- INSIGHTS OF THE ZEPTO SALES

-- q1 find top 10 best value products based on the discount percantage

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2 what are the products high value but out of stock

SELECT DISTINCT name, mrp
FROM zepto 
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;


select count(outofstock) from zepto where outofstock = true;

-- Q3 calcute estimated revenue for each category

SELECT cetegory, ROUND(SUM(discountedsellingprice * availblequantity),0) AS total_revenue
FROM zepto
GROUP BY cetegory
ORDER BY total_revenue;

/* Q4 find all the products where mrp greater then 500rs
AND discount is less than 10% */


SELECT DISTINCT name, mrp, discountPercent 
FROM zepto
WHERE mrp > 500 
AND discountPercent < 10
ORDER BY mrp DESC;

-- Q5 Identify the top 5 categories offering the highest average discount percentage.

SELECT cetegory, ROUND(AVG(discountPercent)) AS avg_discount
FROM zepto
GROUP BY cetegory
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6 Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, discountedSellingPrice, weightIngms, 
ROUND(discountedSellingPrice/weightIngms,2) AS price_per_gram
FROM zepto
WHERE weightInGms > 100
ORDER BY price_per_gram DESC;

-- Q7 Group the products into categories like Low, Medium, Bulk

SELECT DISTINCT name, weightInGms,
CASE
	WHEN weightIngms < 1000 THEN 'LOW'
    WHEN weightIngms < 5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS weight_category
FROM zepto;

-- Q8 What is the total inventory weight per category?

SELECT cetegory, 
SUM(weightingms * availbleQuantity) AS availbe_stock
FROM zepto
GROUP BY cetegory;


SELECT name, COUNT(DISTINCT name) as product_count
from zepto
group by name



