
/*
===============================================================================
Dimension columns
===============================================================================
*/

SELECT DISTINCT 			-- Retrieve a list of unique countries from which customers originate
    country 
FROM gold.dim_customers
ORDER BY country;

SELECT DISTINCT 			-- Retrieve a list of unique categories, subcategories, and products
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
