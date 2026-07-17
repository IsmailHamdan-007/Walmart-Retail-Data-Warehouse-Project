USE Walmart_DatawarehouseDB;

CREATE OR ALTER VIEW Gold.Dim_Date AS
SELECT DISTINCT
    CONVERT(INT, FORMAT(CAST(order_timestamp AS DATE), 'yyyyMMdd')) AS Date_Key,
    CAST(order_timestamp AS DATE) AS Full_Date,
    DAY(order_timestamp) AS Day_Number,
    DATENAME(WEEKDAY, order_timestamp) AS Day_Name,
    MONTH(order_timestamp) AS Month_Number,
    DATENAME(MONTH, order_timestamp) AS Month_Name,
    DATEPART(QUARTER, order_timestamp) AS Quarter,
    YEAR(order_timestamp) AS Year_Number,
    DATEPART(WEEK, order_timestamp) AS Week_Number
FROM Silver.Orders;
GO

SELECT * FROM Gold.Dim_Date;



















