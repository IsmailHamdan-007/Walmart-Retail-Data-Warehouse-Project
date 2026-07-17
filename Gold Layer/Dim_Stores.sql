USE Walmart_DatawarehouseDB;

CREATE VIEW GOLD.Dim_Stores AS
SELECT 
	store_id AS Store_ID,
	store_name AS Store_Name,
	city AS City,
	province AS Province,
	country AS Country,
	is_active AS Activity_Status
FROM Silver.Stores;

SELECT * FROM Gold.Dim_Stores;
















