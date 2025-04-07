/*
=============================================================
Create Database and Schemas
=============================================================
*/


USE master;
GO

-- Drop and recreate the 'Analytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Analytics')
BEGIN
    ALTER DATABASE Analytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Analytics;
END;
GO

-- Create the 'Analytics' database
CREATE DATABASE Analytics;
GO

USE Analytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'S:\Data\Project\Comm\datasets\csv-files\gold.dim_customers.csv'  -- Replace with your directory
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'S:\Data\Project\Comm\datasets\csv-files\gold.dim_products.csv'   -- Replace with your directory
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'S:\Data\Project\Comm\datasets\csv-files\gold.fact_sales.csv'   -- Replace with your directory
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
