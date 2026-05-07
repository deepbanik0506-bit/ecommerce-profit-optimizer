-- SQLite
-- Query 1: List the bottom 10 products by profit margin

select 
    product_name,
    sum(sales) as total_sales,
    sum(profit) as total_profit,
    SUM(profit)*1.0/SUM(sales) as profit_margin
from orders
group by product_name
having total_sales > 5000
order by total_profit ASC
limit 10;


-- Query 2: Check if discount drives losses
select 
    product_name, 
    avg(discount) as avg_discount,
    sum(sales) as total_sales,
    sum(profit) as total_profit
from orders
group by product_name
having total_sales > 5000
order by total_profit asc
limit 10;


-- Qurey 3: is discount worse in specific categories?
select 
    category,
    avg(discount) as avg_discount,
    sum(sales) as total_sales,
    sum(profit) as total_profit,
    sum(profit)/sum(sales) as profit_margin
from orders
group by category
order by total_profit asc;


-- Query 4: at what exact discount does profit level turn negative?
SELECT
    CASE
        WHEN discount <= 0.1 THEN '0-10%'
        WHEN discount <= 0.2 THEN '10-20%'
        WHEN discount <= 0.3 THEN '20-30%'
        WHEN discount <= 0.4 THEN '30-40%'
        ELSE '40%+'
    END AS discount_bucket,
    COUNT(*) AS num_orders,
    AVG(profit) AS avg_profit,
    SUM(profit) AS total_profit
FROM orders
GROUP BY discount_bucket
ORDER BY discount_bucket;

-- Query 5: is this threshold worse for furnitures?
SELECT
    category,
    CASE
        WHEN discount <= 0.1 THEN '0-10%'
        WHEN discount <= 0.2 THEN '10-20%'
        WHEN discount <= 0.3 THEN '20-30%'
        WHEN discount <= 0.4 THEN '30-40%'
        ELSE '40%+'
    END AS discount_bucket,
    COUNT(*) AS num_orders,
    AVG(profit) AS avg_profit,
    SUM(profit) AS total_profit
FROM orders
GROUP BY category, discount_bucket
ORDER BY category, discount_bucket;

--Query 6: If we cap discounts, how much does profits improve?
select 
    sum(profit) as current_profit,
    sum(
        case
            when discount > 0.2 then profit * 0.5
            else profit
        end
    ) as adjusted_profit
from orders;

-- Query 7: Bad Revenue
SELECT
    SUM(sales) AS total_revenue,
    SUM(CASE WHEN profit < 0 THEN sales ELSE 0 END) AS loss_revenue
FROM orders;

--The business is generating revenue at the expense of profitability, with ~20% of sales contributing negatively due to excessive discounting. Implementing category-specific discount caps—particularly for Furniture—could significantly improve margins, with simulations indicating a ~25% increase in total profit.”