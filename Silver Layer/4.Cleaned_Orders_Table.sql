/*
===============================================================================
Load Silver.Orders
===============================================================================
Purpose:
    Load cleaned Orders data from Bronze layer into Silver layer.

Transformations:
    1. Remove duplicate Orders.
    2. Keep latest record.
    3. Trim text columns.
    4. Standardize Active Status.
===============================================================================
*/
USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Orders;

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