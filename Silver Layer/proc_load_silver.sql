/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================

Purpose:
    Loads cleaned and transformed data from the Bronze layer into
    the Silver layer.

Operations:
    - Truncate Silver tables.
    - Clean data.
    - Remove duplicate records.
    - Standardize values.
    - Load into Silver tables.

Tables Loaded:
    1. Customers
    2. Employees
    3. Order_Items
    4. Orders
    5. Products
    6. Stores

Usage:

EXEC Silver.Load_Silver;

===============================================================================
*/
USE Walmart_DatawarehouseDB;

CREATE OR ALTER PROCEDURE Silver.Load_Silver
AS
BEGIN

SET NOCOUNT ON;

DECLARE
    @StartTime DATETIME,
    @EndTime DATETIME,
    @BatchStart DATETIME,
    @BatchEnd DATETIME;

BEGIN TRY

SET @BatchStart = GETDATE();

PRINT '==============================================';
PRINT 'Loading Silver Layer';
PRINT '==============================================';

------------------------------------------------------------
-- Customers
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Customers...';
PRINT '>> Truncating Table: Silver.Customers';
TRUNCATE TABLE Silver.Customers;
PRINT '>> Inserting Data Into: Silver.Customers';
INSERT INTO Silver.Customers
(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    province,
    country,
    created_timestamp,
    updated_timestamp,
    is_active
)
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(email) AS email,
    TRIM(phone) AS phone,
    TRIM(city) AS city,
    TRIM(province) AS province,
    TRIM(country) AS country,
    created_timestamp,
    updated_timestamp,
    CASE
        WHEN is_active='Y' THEN 'Yes'
        WHEN is_active='N' THEN 'No'
        ELSE 'N/A'
    END AS is_active
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY customer_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Customers
) AS C
WHERE rn = 1;

SELECT * FROM Silver.Customers;

SET @EndTime = GETDATE();

PRINT 'Completed Customers in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------
-- Employees
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Employees...';
PRINT '>> Truncating Table: Silver.Employees';
TRUNCATE TABLE Silver.Employees;
PRINT '>> Inserting Data Into: Silver.Employees';
INSERT INTO Silver.Employees
(
    employee_id,
    store_id,
    first_name,
    last_name,
    email,
    job_title,
    salary,
    created_timestamp,
    updated_timestamp,
    is_active
)

SELECT
    employee_id,
    store_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(email) AS email,
    TRIM(job_title) AS job_title,
    salary,
    created_timestamp,
    updated_timestamp,

    CASE
        WHEN is_active='Y' THEN 'Yes'
        WHEN is_active='N' THEN 'No'
        ELSE 'N/A'
    END AS is_active

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY employee_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Employees
) AS EmployeeData

WHERE rn = 1;

SELECT * FROM Silver.Employees;

SET @EndTime = GETDATE();

PRINT 'Completed Employees in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------
-- Order Items
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Order_Items...';

PRINT '>> Truncating Table: Silver.Order_Items';
TRUNCATE TABLE Silver.Order_Items;
PRINT '>> Inserting Data Into: Silver.Order_Items';

INSERT INTO Silver.Order_Items
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    line_amount,
    created_timestamp,
    updated_timestamp,
    is_active
)

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    line_amount,
    created_timestamp,
    updated_timestamp,

    CASE
        WHEN is_active = 'Y' THEN 'Yes'
        WHEN is_active = 'N' THEN 'No'
        ELSE 'N/A'
    END AS is_active

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY order_item_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Order_Items
) AS OrderItems

WHERE rn = 1
      AND order_item_id IS NOT NULL
      AND order_id IS NOT NULL
      AND product_id IS NOT NULL
      AND quantity > 0
      AND unit_price > 0
      AND ABS((quantity * unit_price) - line_amount) <= 0.01;

SELECT * FROM Silver.Order_Items;

SET @EndTime = GETDATE();

PRINT 'Completed Order_Items in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------
-- Orders
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Orders...';

PRINT '>> Truncating Table: Silver.Orders';
TRUNCATE TABLE Silver.Orders;
PRINT '>> Inserting Data Into: Silver.Orders';

INSERT INTO Silver.Orders
(
    order_id,
    customer_id,
    store_id,
    order_timestamp,
    payment_method,
    order_status,
    total_amount,
    created_timestamp,
    updated_timestamp,
    is_active
)

SELECT
    order_id,
    customer_id,
    store_id,
    order_timestamp,
    TRIM(payment_method),
    TRIM(order_status),
    total_amount,
    created_timestamp,
    updated_timestamp,
    CASE
        WHEN is_active='Y' THEN 'Yes'
        WHEN is_active='N' THEN 'No'
        ELSE 'N/A'
    END
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY order_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Orders
) AS OrdersData

WHERE rn = 1
      AND order_id IS NOT NULL
      AND customer_id IS NOT NULL
      AND total_amount > 0;

SELECT * FROM Silver.Orders;

SET @EndTime = GETDATE();

PRINT 'Completed Orders in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------
-- Products
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Products...';

PRINT '>> Truncating Table: Silver.Products';
TRUNCATE TABLE Silver.Products;
PRINT '>> Inserting Data Into: Silver.Products'

INSERT INTO Silver.Products
(
    product_id,
    product_name,
    category,
    brand,
    price,
    created_timestamp,
    updated_timestamp,
    is_active
)

SELECT
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    TRIM(brand) AS brand,
    price,
    created_timestamp,
    updated_timestamp,
    CASE
        WHEN is_active = 'Y' THEN 'Yes'
        WHEN is_active = 'N' THEN 'No'
        ELSE 'N/A'
    END AS is_active
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY product_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Products
) AS ProductData

WHERE rn = 1
      AND product_id IS NOT NULL
      AND price > 0;

SELECT * FROM Silver.Products;

SET @EndTime = GETDATE();

PRINT 'Completed Products in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------
-- Stores
------------------------------------------------------------

SET @StartTime = GETDATE();

PRINT 'Loading Silver.Stores...';

PRINT '>> Truncating Table: Silver.Stores';
TRUNCATE TABLE Silver.Stores;
PRINT '>> Inserting Data Into: Silver.Stores';

INSERT INTO Silver.Stores
(
    store_id,
    store_name,
    city,
    province,
    country,
    created_timestamp,
    updated_timestamp,
    is_active
)

SELECT
    store_id,
    TRIM(store_name) AS store_name,
    TRIM(city) AS city,
    TRIM(province) AS province,
    TRIM(country) AS country,
    created_timestamp,
    updated_timestamp,

    CASE
        WHEN is_active = 'Y' THEN 'Yes'
        WHEN is_active = 'N' THEN 'No'
        ELSE 'N/A'
    END AS is_active

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY store_id
               ORDER BY updated_timestamp DESC
           ) AS rn
    FROM Bronze.Stores
) AS StoreData

WHERE rn = 1
      AND store_id IS NOT NULL;

SELECT * FROM Silver.Stores;

SET @EndTime = GETDATE();

PRINT 'Completed Stores in '
+ CAST(DATEDIFF(SECOND,@StartTime,@EndTime) AS VARCHAR)
+ ' Seconds';

------------------------------------------------------------

SET @BatchEnd = GETDATE();

PRINT '==============================================';
PRINT 'Silver Layer Loaded Successfully';
PRINT 'Total Duration : '
+ CAST(DATEDIFF(SECOND,@BatchStart,@BatchEnd) AS VARCHAR)
+ ' Seconds';
PRINT '==============================================';

END TRY

BEGIN CATCH

PRINT '==============================================';
PRINT 'ERROR OCCURRED DURING SILVER LOAD';
PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR);
PRINT 'Error Message: ' + ERROR_MESSAGE();
PRINT 'Error Line   : ' + CAST(ERROR_LINE() AS VARCHAR);
PRINT '==============================================';

END CATCH

END;
GO

EXEC Silver.Load_Silver;