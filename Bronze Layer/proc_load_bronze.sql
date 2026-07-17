/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Bronze.load_bronze;
===============================================================================
*/
USE Walmart_DatawarehouseDB;

CREATE OR ALTER PROCEDURE Bronze.Load_Bronze AS
	BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
			BEGIN TRY
				PRINT '==============================================='
				PRINT 'Loading Bronze Layer';
				PRINT '==============================================='

				PRINT '-----------------------------------------------'
				PRINT 'Loading Customer Tables'
				PRINT '-----------------------------------------------'

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Customer_Info';

				TRUNCATE TABLE Bronze.Customers;

				BULK INSERT Bronze.Customers
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\customers.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);

				SELECT * FROM Bronze.Customers

				SET @end_time = GETDATE()
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Employees_Info';

				TRUNCATE TABLE Bronze.Employees;

				BULK INSERT Bronze.Employees
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\employees.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);
				SELECT * FROM Bronze.Employees;

				SET @end_time = GETDATE()
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Order_Items';

				TRUNCATE TABLE Bronze.Order_Items;

				BULK INSERT Bronze.Order_Items
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\order_items.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);
				SELECT * FROM Bronze.Order_Items;

				SET @end_time = GETDATE()
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Orders';

				TRUNCATE TABLE Bronze.Orders;

				BULK INSERT Bronze.Orders
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\orders.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);
				SELECT * FROM Bronze.Orders;

				SET @end_time = GETDATE()
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Products';

				TRUNCATE TABLE Bronze.Products;

				BULK INSERT Bronze.Products
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\products.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);
				SELECT * FROM Bronze.Products;

				SET @end_time = GETDATE()
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';

				SET @start_time = GETDATE();
				PRINT '>> Truncating Table: Bronze.Stores';

				TRUNCATE TABLE Bronze.Stores;

				BULK INSERT Bronze.Stores
				FROM 'D:\DataBricks\Walmart_DataWarehouse_Project\data\stores.csv'
				WITH(
				FIRST_ROW = 2,
				FIELDTERMINATOR =';',
				ROWTERMINATOR = '\n',
				TABLOCK
				);
				SELECT * FROM Bronze.Stores;

				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================='
	END CATCH
END

EXEC Bronze.Load_Bronze;


















