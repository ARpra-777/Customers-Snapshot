/*
===============================================================================
Time_Wise_Trends
===============================================================================
*/


WITH yearly_sales AS (				--year-wise-trends
    SELECT
        DATETRUNC(year, order_date) AS order_year,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
)

SELECT 
    order_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_year) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_year)) * 100.0 / NULLIF(LAG(total_sales) OVER (ORDER BY order_year), 0),
        2
    ) AS sales_growth_rate, -- MoM Growth Rate in %
    total_customers,
    total_quantity
FROM yearly_sales
ORDER BY order_year;


WITH monthly_sales AS (					--month-wise trends
    SELECT
        DATETRUNC(month, order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
)

SELECT 
    order_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_month)) * 100.0 / NULLIF(LAG(total_sales) OVER (ORDER BY order_month), 0),
        2
    ) AS sales_growth_rate,
    total_customers,
    total_quantity
FROM monthly_sales
ORDER BY order_month;

