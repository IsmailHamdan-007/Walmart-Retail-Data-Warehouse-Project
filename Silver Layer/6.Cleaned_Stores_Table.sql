/*
===============================================================================
Load Silver.Stores
===============================================================================
Purpose:
    Load cleaned Store data from Bronze layer into Silver layer.

Transformations:
    1. Remove duplicate Store records.
    2. Trim text columns.
    3. Keep latest record.
    4. Standardize Active Status.
===============================================================================
*/
USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Stores;

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

/*
===============================================================================
Validation : Silver.Stores
===============================================================================
*/

-- Total Stores
SELECT COUNT(*) AS TotalStores
FROM Silver.Stores;

-- Duplicate Store IDs
SELECT
    store_id,
    COUNT(*) AS DuplicateCount
FROM Silver.Stores
GROUP BY store_id
HAVING COUNT(*) > 1;

-- NULL Store IDs
SELECT *
FROM Silver.Stores
WHERE store_id IS NULL;

-- Active Status
SELECT DISTINCT is_active
FROM Silver.Stores;