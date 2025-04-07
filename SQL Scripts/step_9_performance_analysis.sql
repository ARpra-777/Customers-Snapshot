/*
===============================================================================
Performance_Analysis (Quarter over Quarter)
===============================================================================
*/

/* Analyze the quarterly performance of products by comparing their sales 
to both the average sales performance of the product and the previous quarter's sales */

WITH quarterly_product_sales AS (
    SELECT
        DATETRUNC(QUARTER, f.order_date) AS order_quarter,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        DATETRUNC(QUARTER, f.order_date),
        p.product_name
)
SELECT
    order_quarter,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter) AS py_sales,                 -- quarter-over-quarter Analysis

    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
    ROUND(
    100.0 * (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter)) 
    / NULLIF(LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_quarter), 0), 
    2
) AS percent_change
FROM quarterly_product_sales
ORDER BY product_name, order_quarter;
