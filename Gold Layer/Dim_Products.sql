USE Walmart_DatawarehouseDB;

CREATE VIEW Gold.Dim_Products AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY product_id) AS Product_Key,
		product_id AS Product_ID,
		product_name AS Product_Name,
		category AS Category,
		brand AS Brand,
		price AS Price,
		is_active AS Active_Status
	FROM Silver.Products;

SELECT * FROM Gold.Dim_Products;






