/*
===============================================================================
Load Silver.Customers
===============================================================================
Purpose:
    Clean and transform customer data from the Bronze layer before loading
    into the Silver layer.

Transformations Performed:
    1. Remove duplicate customer records (keep latest record).
    2. Trim leading/trailing spaces.
    3. Standardize is_active values.
    4. Preserve duplicate email addresses unless business rules require uniqueness.
    5. Load cleaned data into Silver.Customers.

Source:
    Bronze.Customers

Target:
    Silver.Customers
===============================================================================
*/

USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Customers;

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

