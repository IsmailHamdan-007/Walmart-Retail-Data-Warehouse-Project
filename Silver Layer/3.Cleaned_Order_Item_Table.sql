/*
===============================================================================
Load Silver.Order_Items
===============================================================================
Purpose:
    Load cleaned Order Items data from Bronze layer into Silver layer.

Transformations Performed:
    1. Remove duplicate Order Item records.
    2. Keep the latest record based on updated_timestamp.
    3. Validate Quantity and Unit Price.
    4. Validate Line Amount (Quantity × Unit Price).
    5. Standardize is_active values.
    6. Load cleaned data into Silver.Order_Items.

Source:
    Bronze.Order_Items

Target:
    Silver.Order_Items
===============================================================================
*/
USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Order_Items;

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

/*
===============================================================================
Validation : Silver.Order_Items
===============================================================================
Purpose:
    Verify data successfully loaded into Silver layer.
===============================================================================
*/

-- Total Records
SELECT COUNT(*) AS Total_Order_Items
FROM Silver.Order_Items;

-- Duplicate Order Item IDs
SELECT
    order_item_id,
    COUNT(*) AS Duplicate_Count
FROM Silver.Order_Items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

-- NULL Primary Keys
SELECT *
FROM Silver.Order_Items
WHERE order_item_id IS NULL;

-- Validate Business Rule
SELECT *
FROM Silver.Order_Items
WHERE ABS((quantity * unit_price) - line_amount) > 0.01;

-- Active Status
SELECT DISTINCT is_active
FROM Silver.Order_Items;