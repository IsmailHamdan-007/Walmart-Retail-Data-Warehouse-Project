USE Walmart_DatawarehouseDB;


CREATE VIEW Gold.DIM_Customers AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY customer_id) AS Customer_Key,
		C.customer_id AS Customer_ID,
		C.first_name AS First_Name,
		C.last_name AS Last_Name,
		C.email AS EMail,
		C.phone AS Phone,
		C.city AS City,
		C.country AS Country,
		C.province AS Province,
		C.is_active AS Active_Status
	FROM Silver.Customers C;

SELECT * FROM Gold.DIM_Customers;


