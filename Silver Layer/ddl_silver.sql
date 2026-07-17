USE Walmart_DatawarehouseDB;


IF OBJECT_ID('Silver.Customers', 'U') IS NOT NULL
	DROP TABLE Silver.Customers;

CREATE TABLE Silver.Customers(
	customer_id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	phone VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(50),
	country VARCHAR(50),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(50)
);

IF OBJECT_ID('Silver.Employees', 'U') IS NOT NULL
	DROP TABLE Silver.Employees;

CREATE TABLE Silver.Employees(
	employee_id INT,
	store_id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	job_title VARCHAR(100),
	salary DECIMAL(10, 2),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(50)
);

SELECT * FROM Silver.Employees;

IF OBJECT_ID('Silver.Order_Items', 'U') IS NOT NULL
	DROP TABLE Silver.Order_Items;

CREATE TABLE Silver.Order_Items
(
	order_item_id INT,
	order_id INT,
	product_id INT,
	quantity INT,
	unit_price DECIMAL(10, 2),
	line_amount DECIMAL(10, 2),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(50)
);

IF OBJECT_ID('Silver.Orders', 'U') IS NOT NULL
	DROP TABLE Silver.Orders;

CREATE TABLE Silver.Orders(
	order_id INT,
	customer_id INT,
	store_id INT,
	order_timestamp DATETIME,
	payment_method VARCHAR(50),
	order_status VARCHAR(50),
	total_amount DECIMAL(10, 2),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(50)
);


IF OBJECT_ID('Silver.Products', 'U') IS NOT NULL
	DROP TABLE Silver.Products;

CREATE TABLE Silver.Products(
	product_id VARCHAR(50),
	product_name VARCHAR(50),
	category VARCHAR(50),
	brand VARCHAR(50),
	price DECIMAL(10, 2),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(20)
);

IF OBJECT_ID('Silver.Stores', 'U') IS NOT NULL
	DROP TABLE Silver.Stores;

CREATE TABLE Silver.Stores(
	store_id INT,
	store_name VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(50),
	country VARCHAR(50),
	created_timestamp DATETIME,
	updated_timestamp DATETIME,
	is_active VARCHAR(50)
);





























