#1st problem
# Find Top 3 outlets by cuisine type without using limit and top function

with cte as (
SELECT Cuisine,Restaurant_id, COUNT(*) AS NumberOfProducts 
FROM orders
GROUP BY Cuisine, Restaurant_id)
SELECT * from (
SELECT *
,ROW_NUMBER() over(partition by cuisine order by NumberOfProducts desc) AS rn
FROM cte ) a
WHERE rn<=3


#2nd problem
# Find the daily new customer count from the launch date(everyday how many new customers are we acquiring)

with cte as (
SELECT Customer_code , cast(MIN(placed_at) AS date) AS FirstOrderDate
FROM orders
GROUP by Customer_code)

SELECT FirstOrderDate, COUNT(*) as NoOfNewCustomer
FROM cte
GROUP by FirstOrderDate
ORDER by FirstOrderDate;


#3rd problem
# Count of all the users who were acquired in jan 2025 and only placed one order in jan and did not place any other order.


(SELECT Customer_code , COUNT(*) AS NoOfOrders
FROM orders
where MONTH(placed_at)=1 and YEAR(placed_at)=2025
and Customer_code not in (select distinct Customer_code
from orders
where not (MONTH(placed_at)=1 and YEAR(placed_at)=2025)
)

group by Customer_code
having COUNT(*)=1) 


#4th problem
#List all the customers with no order in the last 7 days but were acquired one month ago with their first order on promo.


WITH cte AS (SELECT Customer_code, 
    MIN(placed_at) AS FirstOrderDate,
    MAX(placed_at) AS LatestOrderDate
  FROM orders
  GROUP BY Customer_code
)

SELECT cte.*, o.Promo_code_Name AS FirstOrderPromo
FROM cte
INNER JOIN orders o 
  ON cte.Customer_code = o.Customer_code 
  AND cte.FirstOrderDate = o.Placed_at
WHERE cte.LatestOrderDate < NOW() - INTERVAL 7 DAY
  AND cte.FirstOrderDate < NOW() - INTERVAL 1 MONTH
  AND o.Promo_code_Name IS NOT NULL;
  
  #5th question
  #Growth team is planning to create a trigger that will target customers after their every third order with a personalised communication and they have asked you to create a query for this.

with cte as (
select *
, ROW_NUMBER() over(partition by Customer_code order by Placed_at) as OrderNumber
from orders
)
select *
from cte 
where OrderNumber%3=0  and DATE(Placed_at) = '2025-01-15';


#6th question
#List customers who placed more than 1 order and all orders on a promo only
select Customer_code, COUNT(*) AS NoOfOrders, COUNT(Promo_code_Name) AS PromoOrders
from orders
group by Customer_code
having COUNT(*)>1 and COUNT(*)=COUNT(Promo_code_Name);


#7th question
#What percent of customers were organically aquired in jan 2025. (placed their first order without promo code).


with cte as (
select * 
,ROW_NUMBER() over(partition by Customer_code order by placed_at) as rn
from orders
where MONTH(placed_at)=1
)
select COUNT(case when rn=1 and promo_code_Name is null then Customer_code end)*100.0/COUNT(distinct Customer_code)
from cte





  
  







 
























