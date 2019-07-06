/*		 Project 2 Comp 1630			 */
USE master;
GO

/**********		PART A		**************/
/* Create a Database for Customer Orders */
--Drop the database first if it is already exists 
PRINT 'Droping Cus_Order Database if EXISTS'

IF EXISTS (
		SELECT *
		FROM sysdatabases
		WHERE name = 'Cus_Orders'
		)
BEGIN
	RAISERROR (
			'Dropping existing Cus_Orders ....'
			,0
			,1
			)

	DROP DATABASE Cus_Orders
END
GO

PRINT CHAR(13) + '**********		PART A		**************'
GO

-- Q1 Create the database 
PRINT 'Creating Cus_Order Database'

CREATE DATABASE Cus_Orders;
GO

USE Cus_Orders;
GO

--Q2 Create a user defined data types
CREATE TYPE intidtype
FROM INT NOT NULL;
GO

CREATE TYPE charidtype
FROM CHAR(5) NOT NULL;
GO

CREATE TYPE scharidtype
FROM CHAR(3) NOT NULL;
GO

PRINT 'User defined type created'
GO

WAITFOR DELAY '00:00:01';
GO

--Q3 Create the tables
CREATE TABLE customers (
	customer_id charidtype
	,name VARCHAR(50) NOT NULL
	,contact_name VARCHAR(30)
	,title_id scharidtype
	,address VARCHAR(50)
	,city VARCHAR(20)
	,region VARCHAR(15)
	,country_code VARCHAR(10)
	,country VARCHAR(15)
	,phone VARCHAR(20)
	,fax VARCHAR(20)
	);
GO

PRINT CHAR(13) + 'Customers table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE orders (
	order_id intidtype
	,customer_id charidtype
	,employee_id intidtype
	,shipping_name VARCHAR(50) NOT NULL
	,shipping_address VARCHAR(50)
	,shipping_city VARCHAR(20)
	,shipping_region VARCHAR(15)
	,shipping_country_code VARCHAR(10)
	,shipping_country VARCHAR(15)
	,shipper_id intidtype
	,order_date DATETIME
	,required_date DATETIME
	,shipped_date DATETIME
	,freight_charge MONEY
	);
GO

PRINT 'Orders table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE order_details (
	order_id intidtype
	,product_id intidtype
	,quantity intidtype
	,discount FLOAT(24) NOT NULL
	);
GO

PRINT 'Order_details table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE products (
	product_id intidtype
	,supplier_id intidtype
	,name VARCHAR(50) NOT NULL
	,alternate_name VARCHAR(40)
	,quantity_per_unit VARCHAR(25)
	,unit_price MONEY
	,quantity_in_stock INT
	,units_on_order INT
	,reorder_level INT
	);
GO

PRINT 'Products table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE shippers (
	shipper_id intidtype IDENTITY(1, 1)
	,name VARCHAR(20) NOT NULL
	);
GO

PRINT 'Shippers table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE suppliers (
	supplier_id intidtype IDENTITY(1, 1)
	,name VARCHAR(40) NOT NULL
	,address VARCHAR(30)
	,city VARCHAR(20)
	,province CHAR(2)
	);
GO

PRINT 'Suppliers table created'
GO

WAITFOR DELAY '00:00:01';
GO

CREATE TABLE titles (
	title_id scharidtype
	,description VARCHAR(35) NOT NULL
	);
GO

PRINT 'Titles table created'
GO

WAITFOR DELAY '00:00:01';
GO

--Q4 Add Primary
ALTER TABLE customers ADD PRIMARY KEY (customer_id);
GO

ALTER TABLE orders ADD PRIMARY KEY (order_id);
GO

ALTER TABLE products ADD PRIMARY KEY (product_id);
GO

ALTER TABLE order_details ADD PRIMARY KEY (
	order_id
	,product_id
	);
GO

ALTER TABLE shippers ADD PRIMARY KEY (shipper_id);
GO

ALTER TABLE suppliers ADD PRIMARY KEY (supplier_id);
GO

ALTER TABLE titles ADD PRIMARY KEY (title_id);
GO

PRINT CHAR(13) + 'Primary Keys Added'
GO

--Q4 Add Foreign Keys
ALTER TABLE customers ADD FOREIGN KEY (title_id) REFERENCES titles (title_id);
GO

ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id);
GO

ALTER TABLE orders ADD FOREIGN KEY (shipper_id) REFERENCES shippers (shipper_id);
GO

ALTER TABLE order_details ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);
GO

ALTER TABLE order_details ADD FOREIGN KEY (product_id) REFERENCES products (product_id);
GO

ALTER TABLE products ADD FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id);
GO

PRINT 'Foreign Keys Added'
GO

WAITFOR DELAY '00:00:01';
GO

--Q5 Set the constraints 
-- Country should default to Canada
ALTER TABLE customers ADD CONSTRAINT DF_Country DEFAULT 'Canada'
FOR country;
GO

-- Required_date should default to today’s date plus ten days 
ALTER TABLE orders ADD CONSTRAINT DF_Date DEFAULT DATEADD (
	DAY
	,10
	,getdate()
	)
FOR Required_date;
GO

-- Quantity must be greater than or equal to 1
ALTER TABLE order_details ADD CONSTRAINT CHK_Qty CHECK (quantity >= 1);
GO

-- Reorder_level must be greater than or equal to 1
-- Quantity_in_stock value must not be greater than 150
ALTER TABLE products ADD CONSTRAINT CHK_Reorder_Qty CHECK (
	reorder_level >= 1
	AND quantity_in_stock <= 150
	);
GO

-- Province should default to BC
ALTER TABLE suppliers ADD CONSTRAINT DF_Province DEFAULT 'BC'
FOR province;
GO

PRINT 'Constraints added to the tables'
GO

WAITFOR DELAY '00:00:01';
GO

--Q6 Load the data into created tables using the files in the "C:\TextFiles" folder
BULK INSERT titles
FROM 'C:\TextFiles\titles.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the titles table'
GO

BULK INSERT suppliers
FROM 'C:\TextFiles\suppliers.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the suppliers table'
GO

BULK INSERT shippers
FROM 'C:\TextFiles\shippers.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the shippers table'
GO

BULK INSERT customers
FROM 'C:\TextFiles\customers.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the customers table'
GO

BULK INSERT products
FROM 'C:\TextFiles\products.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the products table'
GO

BULK INSERT order_details
FROM 'C:\TextFiles\order_details.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the order_details table'
GO

BULK INSERT orders
FROM 'C:\TextFiles\orders.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the orders table'
GO

WAITFOR DELAY '00:00:01';
GO

/**********		PART B		**************/
PRINT CHAR(13) + '**********		PART B		**************'
GO

--Q1 List the customer id, name, city, and country from the customer table.
SELECT customer_id
	,name
	,city
	,country
FROM customers
ORDER BY customer_id;
GO

--Q2 Add a new column called active to the customer's table using the ALTER statement.
-- The only valid values are 1 or 0. The default should be 1.
ALTER TABLE customers ADD active BIT NOT NULL DEFAULT(1);
GO

PRINT CHAR(13) + 'Column named Active added to the customer''s table'
GO

--Q3 List all the orders where the order date is between January 1 and December 31, 2001.
SELECT orders.order_id
	,'product_name' = products.name
	,'customer_name' = customers.name
	,'order_date' = CONVERT(VARCHAR, orders.order_date, 100)
	,'new_shipped_date' = CONVERT(VARCHAR, DATEADD(DAY, 17, shipped_date), 100)
	,'order_cost' = order_details.quantity * products.unit_price
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.order_date BETWEEN 'JAN 1, 2001'
		AND 'DEC 31, 2001';
GO

--Q4 List all the orders that have not been shipped.
SELECT customers.customer_id
	,customers.name
	,customers.phone
	,orders.order_id
	,orders.order_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NULL
ORDER BY customers.name
GO

--Q5 List all the customers where the region is NULL.  
SELECT customers.customer_id
	,customers.name
	,customers.city
	,titles.description
FROM customers
INNER JOIN titles ON customers.title_id = titles.title_id
WHERE customers.region IS NULL
GO

--Q6 List the products where the reorder level is higher than the quantity in stock.
SELECT 'supplier_name' = suppliers.name
	,'product_name' = products.name
	,products.reorder_level
	,products.quantity_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE reorder_level > quantity_in_stock
ORDER BY suppliers.name
GO

--Q7 Calculate the length in years from January 1, 2008 
-- and when an order was shipped where the shipped date is not null.
SELECT orders.order_id
	,customers.name
	,customers.contact_name
	,'shipped_date' = REPLACE(CONVERT(VARCHAR, orders.shipped_date, 107), ',', '')
	,'elapsed' = DATEDIFF(YEAR, orders.shipped_date, 'January 1, 2008')
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NOT NULL
ORDER BY order_id
	,elapsed
GO

--Q8 List number of customers with names beginning with each letter of the alphabet.
SELECT 'name' = LEFT(name, 1)
	,'total' = COUNT(*)
FROM customers
WHERE LEFT(name, 1) <> 'S'
GROUP BY LEFT(name, 1)
HAVING (COUNT(*) > 1)
ORDER BY LEFT(name, 1)
GO

--Q9 List the order details where the quantity is greater than 100
SELECT order_details.order_id
	,order_details.quantity
	,products.product_id
	,products.reorder_level
	,suppliers.supplier_id
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE order_details.quantity > 100
ORDER BY order_details.order_id
GO

--Q10 List the products which contain tofu or chef in their name.  
SELECT product_id
	,name
	,quantity_per_unit
	,unit_price
FROM products
WHERE name LIKE '%tofu%'
	OR name LIKE '%chef%'
ORDER BY name;
GO

/**********		PART C		**************/
PRINT CHAR(13) + '**********		PART C		**************'
GO

--Q1 Create an employee table 
CREATE TABLE employee (
	employee_id intidtype
	,last_name VARCHAR(30) NOT NULL
	,first_name VARCHAR(15) NOT NULL
	,address VARCHAR(30)
	,city VARCHAR(20)
	,province CHAR(2)
	,postal_code VARCHAR(7)
	,phone VARCHAR(10)
	,birth_date DATETIME NOT NULL
	);
GO

PRINT 'Employee table created'
GO

--Q2 The primary key for the employee table should be the employee id.
ALTER TABLE employee ADD PRIMARY KEY (employee_id);
GO

--Q3 Load the data into the employee table using the employee.txt file
BULK INSERT employee
FROM 'C:\TextFiles\employee.txt' WITH (
		CODEPAGE = 1252
		,DATAFILETYPE = 'char'
		,FIELDTERMINATOR = '\t'
		,KEEPNULLS
		,ROWTERMINATOR = '\n'
		)
GO

PRINT 'Data added to the employee table'
GO

ALTER TABLE orders ADD FOREIGN KEY (employee_id) REFERENCES employee (employee_id);
GO

--Q4 Using the INSERT statement, add the shipper Quick Express to the shippers table.
INSERT INTO shippers
VALUES ('Quick Express')
GO

--Q5 Using the UPDATE statement, increase the unit price in the products table of all rows with a current unit price between $5.00 and $10.00 by 5%
UPDATE products
SET unit_price = unit_price * 1.05
WHERE unit_price BETWEEN 5.00
		AND 10.00
GO

--Q6 Using the UPDATE statement, change the fax value to Unknown for all rows in the customers table where the current fax value is NULL
UPDATE customers
SET fax = 'Unknown'
WHERE fax IS NULL
GO

--Q7 Create a view called vw_order_cost to list the cost of the orders.
CREATE VIEW vw_order_cost
AS
SELECT orders.order_id
	,orders.order_date
	,products.product_id
	,customers.name
	,'order_cost' = order_details.quantity * products.unit_price
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
GO

SELECT *
FROM vw_order_cost
WHERE order_id BETWEEN 10000
		AND 10200;
GO

--Q8 Create a view called vw_list_employees to list all the employees and all the columns in the employee table.
CREATE VIEW vw_list_employees
AS
SELECT *
FROM employee
GO

SELECT employee_id
	,'name' = last_name + ', ' + first_name
	,'birth_date' = CONVERT(VARCHAR(10), birth_date, 102)
FROM vw_list_employees
WHERE employee_id IN (
		5
		,7
		,9
		);
GO

--Q9 Create a view called vw_all_orders to list all the orders.
CREATE VIEW vw_all_orders
AS
SELECT orders.order_id
	,customers.customer_id
	,customers.name
	,customers.city
	,customers.country
	,orders.shipped_date --,100)
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
GO

SELECT order_id
	,customer_id
	,name
	,city
	,country
	,'shipped_date' = CONVERT(VARCHAR(11), shipped_date, 100)
FROM vw_all_orders
WHERE vw_all_orders.shipped_date BETWEEN 'January 1, 2002'
		AND 'December 31, 2002'
ORDER BY name
	,country
GO

--Q10 Create a view listing the suppliers and the items they have shipped.
CREATE VIEW vw_supplier_shipments
AS
SELECT suppliers.supplier_id
	,'supplier_name' = suppliers.name
	,products.product_id
	,'product_name' = products.name
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id
GO

SELECT *
FROM vw_supplier_shipments
GO

/**********		PART D		**************/
PRINT CHAR(13) + '**********		PART D		**************'
GO

--Q1 Create a stored procedure called sp_customer_city displaying the customers living in a particular city
CREATE PROCEDURE sp_customer_city @vcity VARCHAR(20)
AS
SELECT customer_id
	,name
	,address
	,city
	,phone
FROM customers
WHERE city = @vcity
GO

EXEC sp_customer_city @vcity = 'London';
GO

--Q2 Create a stored procedure called sp_orders_by_dates displaying the orders shipped between particular dates.
CREATE PROCEDURE sp_orders_by_dates (
	@vs_date DATETIME
	,@ve_date DATETIME
	)
AS
SELECT orders.order_id
	,orders.customer_id
	,'customer_name' = customers.name
	,'shipper_name' = shippers.name
	,'shipped_date' = orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN shippers ON orders.shipper_id = shippers.shipper_id
WHERE orders.shipped_date BETWEEN @vs_date
		AND @ve_date
GO

EXEC sp_orders_by_dates @vs_date = 'January 1, 2003'
	,@ve_date = 'June 30, 2003';
GO

--Q3 Create a stored procedure called sp_product_listing listing a specified product ordered during a specified month and year.
CREATE PROCEDURE sp_product_listing (
	@vproduct VARCHAR(50)
	,@vmonth VARCHAR(10)
	,@vyear INT
	)
AS
SELECT 'product_name' = products.name
	,products.unit_price
	,products.quantity_in_stock
	,suppliers.name
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
INNER JOIN order_details ON products.product_id = order_details.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
WHERE products.name LIKE @vproduct
	AND DATENAME(month, order_date) = @vmonth
	AND YEAR(order_date) = @vyear
GO

EXEC sp_product_listing @vproduct = '%Jack%'
	,@vmonth = 'June'
	,@vyear = 2001;
GO

--Q4 Create a DELETE trigger on the order_details table 
CREATE TRIGGER DeleteOrderDetails ON order_details
FOR DELETE
AS
DECLARE @vor_id intidtype
	,@vpro_id intidtype
	,@vqty intidtype

SELECT @vor_id = order_id
	,@vpro_id = product_id
	,@vqty = quantity
FROM deleted

IF @@ROWCOUNT = 0
	SELECT 'Record not found in order_details table'
ELSE
BEGIN
	-- do update 
	UPDATE products
	SET quantity_in_stock = quantity_in_stock + @vqty
	WHERE Product_ID = @vpro_id

	-- display details
	SELECT Product_ID = @vpro_id
		,'Product Name' = products.name
		,'Quentity being deleted from order' = @vqty
		,'In stock Quantity after Deletion' = products.quantity_in_stock
	FROM products
	WHERE Product_ID = @vpro_id
END
GO

DELETE order_details
WHERE order_id = 10001
	AND product_id = 25
GO

--Q5 Create an INSERT and UPDATE trigger called tr_check_qty on the order_details table 
CREATE TRIGGER tr_check_qty ON order_details
FOR INSERT
	,UPDATE
AS
DECLARE @vuntis_orderd INT
	,@vproduct_id intidtype

SELECT @vuntis_orderd = quantity
	,@vproduct_id = product_id
FROM inserted

SELECT quantity_in_stock
FROM products
WHERE product_id = @vproduct_id
	AND quantity_in_stock >= @vuntis_orderd

IF (@@ROWCOUNT = 0)
BEGIN
	PRINT 'No enough quantity can be ordered'

	ROLLBACK TRANSACTION
END
GO

UPDATE order_details
SET quantity = 30
WHERE order_id = '10044'
	AND product_id = 7
GO

--Q6 Create a stored procedure called sp_del_inactive_cust to delete customers that have no orders.
CREATE PROCEDURE sp_del_inactive_cust
AS
DECLARE @vcust_id charidtype

SELECT @vcust_id = customer_id
FROM customers
WHERE customer_id NOT IN (
		SELECT DISTINCT customer_id
		FROM orders
		)

IF (@@ROWCOUNT = 0)
	PRINT 'No customers deleted'
ELSE
BEGIN
	DELETE
	FROM customers
	WHERE customer_id = @vcust_id
END
GO

EXEC sp_del_inactive_cust
GO

--Q7	Create a stored procedure called sp_employee_information to display the employee information for a particular employee.
CREATE PROCEDURE sp_employee_information (@vemp_id intidtype)
AS
SELECT *
FROM employee
WHERE employee_id = @vemp_id
GO

EXEC sp_employee_information @vemp_id = 5
GO

--Q8 Create a stored procedure called sp_reorder_qty 
CREATE PROCEDURE sp_reorder_qty (@vunit_value INT)
AS
SELECT products.product_id
	,suppliers.name
	,suppliers.address
	,suppliers.city
	,suppliers.province
	,'qty' = products.quantity_in_stock
	,products.reorder_level
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE (products.quantity_in_stock - products.reorder_level) < @vunit_value
GO

EXEC sp_reorder_qty @vunit_value = 5
GO

--Q9 Create a stored procedure called sp_unit_prices for the product table
CREATE PROCEDURE sp_unit_prices (
	@vslimit INT
	,@velimit INT
	)
AS
SELECT product_id
	,name
	,alternate_name
	,unit_price
FROM products
WHERE unit_price BETWEEN @vslimit
		AND @velimit
GO

EXEC sp_unit_prices @vslimit = 5
	,@velimit = 10
GO

