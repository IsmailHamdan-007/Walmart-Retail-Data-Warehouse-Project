USE Walmart_DatawarehouseDB;

CREATE OR ALTER VIEW Gold.Fact_Sales AS
SELECT
    o.order_id AS Order_ID,
    o.customer_id AS Customer_ID,
    oi.product_id AS Product_ID,
    o.store_id Store_ID,
    CONVERT(INT, FORMAT(CAST(o.order_timestamp AS DATE), 'yyyyMMdd')) AS Date_Key,
    oi.quantity AS Quantity,
    oi.unit_price AS Unit_Price,
    oi.line_amount AS Sales_Amount,
    o.payment_method AS Payment_Method,
    o.order_status AS Order_Status
FROM Silver.Orders o
INNER JOIN Silver.Order_Items oi
    ON o.order_id = oi.order_id;
GO

SELECT * FROM Gold.Fact_Sales;


SELECT 
	D.Month_Name AS MONTHS,
	D.Year_Number AS Years,
	P.Product_Name,
	P.Category,
	SUM(F.Sales_Amount) AS Sales_Amount
FROM Gold.Dim_Products P
LEFT JOIN Gold.Fact_Sales F
	ON P.Product_ID = F.Product_ID
LEFT JOIN Gold.Dim_Date D
	ON F.Date_Key = D.Date_Key
GROUP BY P.Product_Name,
	P.Category, D.Month_Name, D.Year_Number
ORDER BY Sales_Amount DESC;




