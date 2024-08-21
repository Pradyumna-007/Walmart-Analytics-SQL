SELECT * FROM walmart.w_sales;

#Necessary Altrations to table
ALTER TABLE walmart.w_sales RENAME COLUMN `Product line` TO product_line;
ALTER TABLE walmart.w_sales RENAME COLUMN `Tax 5%` TO VAT;
ALTER TABLE walmart.w_sales RENAME COLUMN `Customer type` TO Cust_type;
ALTER TABLE walmart.w_sales RENAME COLUMN `gross margin percentage` TO gross_margin_per;
ALTER TABLE walmart.w_sales RENAME COLUMN `gross income` TO  gross_income;

#FEATURE ENGINEERING
#TIME OF DAY
SELECT time, 
(CASE
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END) AS time_of_day
FROM walmart.w_sales;
ALTER TABLE walmart.w_sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE walmart.w_sales
SET time_of_day=(CASE 
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);

#DAY NAME
SELECT date,dayname(date)
FROM walmart.w_sales;

ALTER TABLE walmart.w_sales ADD COLUMN day_name VARCHAR(10);
UPDATE walmart.w_sales SET day_name=dayname(date);

#MONTH NAME
SELECT date,monthname(date)
FROM walmart.w_sales;

ALTER TABLE walmart.w_sales ADD COLUMN month_name VARCHAR(15);
UPDATE walmart.w_sales SET month_name=monthname(date);

# How many unique cities does the data have?
SELECT DISTINCT city FROM walmart.w_sales;

#In which city is each branch?
SELECT DISTINCT city, Branch FROM walmart.w_sales;

# Product
# 1.How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) FROM wallmart.w_sales;

#2.What is the most common payment method?
select payment, count(payment) as most_used 
from wallmart.w_sales 
group by payment;

#3.What is the most selling product line?
SELECT product_line, count(product_line) AS cnt
FROM walmart.w_sales 
GROUP BY product_line
ORDER BY cnt DESC;

#4.What is the total revenue by month?
SELECT month_name AS month,
SUM(total) AS total_revenue
FROM walmart.w_sales 
GROUP BY month_name 
ORDER BY total_revenue DESC;

#5.What month had the largest COGS?
SELECT month_name AS month,
SUM(cogs) as cogs
FROM walmart.w_sales 
GROUP BY month_name 
ORDER BY cogs DESC;

#6.What product line had the largest revenue?
SELECT product_line, SUM(Total) AS tol_rev 
FROM walmart.w_sales
GROUP BY product_line
ORDER BY tol_rev DESC;

#7.What is the city with the largest revenue?
SELECT Branch,City,SUM(Total) AS tol_rev 
FROM walmart.w_sales
GROUP BY Branch,City
ORDER BY tol_rev DESC;

#8.What product line had the largest VAT?
SELECT product_line, AVG(VAT) AS avg_tax
from walmart.w_sales 
GROUP BY product_line
ORDER BY avg_tax DESC;

#9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line,
CASE
WHEN AVG(Quantity)>5 THEN "Good" ELSE "Bad"
END AS remark 
FROM walmart.w_sales 
GROUP BY product_line;

#10.Which branch sold more products than average product sold?
SELECT Branch, SUM(Quantity) AS qunt
FROM walmart.w_sales
GROUP BY Branch 
HAVING sum(Quantity)>(SELECT AVG(Quantity) FROM walmart.w_sales);

#11.What is the most common product line by gender?
SELECT Gender, product_line, COUNT(gender) AS tol_cnt
FROM wallmart.w_sales 
GROUP BY Gender,product_line
ORDER BY tol_cnt;

#12.What is the average rating of each product line?
SELECT round(AVG(rating),2) AS avg_rate,
product_line FROM walmart.w_sales
GROUP BY product_line 
ORDER BY avg_rate;

#Sales
#1.Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales
FROM walmart.w_sales WHERE day_name="Sunday"
GROUP BY time_of_day
ORDER BY total_sales;

#2.Which of the customer types brings the most revenue?
SELECT Cust_type,SUM(Total) AS tol_rev
FROM walmart.w_sales
GROUP BY Cust_type
ORDER BY tol_rev DESC;

#3.Which city has the largest tax percent/ VAT (Value Added Tax)?
select City,round(avg(VAT),2) as avg_tax
from walmart.w_sales
group by City
order by avg_tax desc;

#4.Which customer type pays the most in VAT?
SELECT Cust_type,ROUND(AVG(VAT),2) AS avg_tax 
FROM walmart.w_sales
GROUP BY Cust_type
ORDER BY avg_tax DESC;

#Customer
#1.How many unique customer types does the data have?
SELECT DISTINCT Cust_type 
FROM walmart.w_sales;

#2.How many unique payment methods does the data have?
SELECT DISTINCT Payment 
FROM walmart.w_sales;

#3.What is the most common customer type?
SELECT Cust_type, COUNT(*) AS count 
FROM walmart.w_sales
GROUP BY Cust_type
ORDER BY count DESC;

#4.Which customer type buys the most?
SELECT Cust_type, COUNT(*)  AS buys 
FROM walmart.w_sales
GROUP BY Cust_type
ORDER BY buys DESC;

#5.What is the gender of most of the customers?
SELECT Gender, COUNT(*) AS gdr_cnt
FROM walmart.w_sales
GROUP BY Gender
ORDER BY gdr_cnt DESC;

#6.What is the gender distribution per branch?
SELECT Gender, COUNT(*) 
FROM walmart.w_sales WHERE Branch='A'
GROUP BY Gender
ORDER BY Gender DESC;
SELECT Gender, COUNT(*) 
FROM walmart.w_sales WHERE Branch='B'
GROUP BY Gender
ORDER BY Gender DESC;
SELECT Gender, COUNT(*) 
FROM walmart.w_sales WHERE Branch='C'
GROUP BY Gender
ORDER BY Gender DESC;

#7.Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rate
FROM walmart.w_sales
GROUP BY time_of_day 
ORDER BY avg_rate DESC;

#8.Which time of the day do customers give most ratings per branch?
SELECT time_of_day,Branch, AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='A'
GROUP BY time_of_day 
ORDER BY avg_rat desc;
SELECT time_of_day,Branch, AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='B'
GROUP BY time_of_day 
ORDER BY avg_rat desc;
SELECT time_of_day,Branch, AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='C'
GROUP BY time_of_day 
ORDER BY avg_rat desc;

#9.Which day fo the week has the best avg ratings?
SELECT day_name,AVG(rating) AS avg_rat
FROM walmart.w_sales
GROUP BY day_name
ORDER BY avg_rat DESC;

#10.Which day of the week has the best average ratings per branch?
SELECT day_name,Branch,AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='A'
GROUP BY day_name
ORDER BY avg_rat desc;
SELECT day_name,Branch,AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='B'
GROUP BY day_name
ORDER BY avg_rat desc;
SELECT day_name,Branch,AVG(rating) AS avg_rat
FROM walmart.w_sales WHERE Branch='C'
GROUP BY day_name
ORDER BY avg_rat desc;
