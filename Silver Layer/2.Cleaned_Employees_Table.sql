/*
===============================================================================
Load Silver.Employees
===============================================================================
Purpose:
    Load cleaned employee records from Bronze layer into Silver layer.

Transformations:
    1. Remove duplicate employee records.
    2. Trim text columns.
    3. Standardize is_active values.
    4. Preserve duplicate emails unless business rules require uniqueness.
===============================================================================
*/

USE Walmart_DatawarehouseDB;

TRUNCATE TABLE Silver.Employees;

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

/*
===============================================================================
Validation : Silver.Employees
===============================================================================
Purpose:
    Verify successful loading into Silver layer.
===============================================================================
*/

-- Total Records
SELECT COUNT(*) AS TotalEmployees
FROM Silver.Employees;

-- Duplicate Employee IDs
SELECT
    employee_id,
    COUNT(*) AS DuplicateCount
FROM Silver.Employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- NULL Employee IDs
SELECT *
FROM Silver.Employees
WHERE employee_id IS NULL;

-- Active Status Values
SELECT DISTINCT is_active
FROM Silver.Employees;