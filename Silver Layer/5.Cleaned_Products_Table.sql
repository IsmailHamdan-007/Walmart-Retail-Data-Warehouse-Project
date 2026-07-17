/*
===============================================================================
Load Silver.Products
===============================================================================
Purpose:
    Load cleaned Product data from Bronze layer into Silver layer.

Transformations:
    1. Remove duplicate products.
    2. Trim text columns.
    3. Keep latest record.
    4. Standardize Active Status.
===============================================================================
*/
USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Products;

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

/*
===============================================================================
Validation : Silver.Products
===============================================================================
*/

-- Total Products
SELECT COUNT(*) AS TotalProducts
FROM Silver.Products;

-- Duplicate Product IDs
SELECT
    product_id,
    COUNT(*) AS DuplicateCount
FROM Silver.Products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- NULL Product IDs
SELECT *
FROM Silver.Products
WHERE product_id IS NULL;

-- Active Status Values
SELECT DISTINCT is_active
FROM Silver.Products;