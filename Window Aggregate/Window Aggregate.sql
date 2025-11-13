USE SalesDB;

/*
	-- Find the total number of orders.
	-- Find the total number of orders for each customer.
	-- Find the total number of orders
	Additionally provide details such order id, order date.
*/
SELECT
	COUNT(*) AS TotalOrders
FROM
	Sales.Orders;

SELECT
	OrderID,
	OrderDate,
	ProductID,
	COUNT(OrderID) OVER() AS TotalOrders
FROM
	Sales.Orders;

SELECT
	OrderID,
	OrderDate,
	ProductID,
	CustomerID,
	COUNT(OrderID) OVER(PARTITION BY CustomerID) AS OrdersByCustomers
FROM
	Sales.Orders;

/*
	-- Find the total number of customers,
	additionally provide all customer`s details.
	-- Find the total number of scores for the customers.
*/
SELECT
	*,
	COUNT(*) OVER() AS TotalCustomersByStar,
	COUNT(1) OVER() AS TotalCustomersByOne,
	COUNT(Score) OVER() AS Customers,
	COUNT(COALESCE(Score, 0)) OVER() AS TotalScores
FROM
	Sales.Customers;

-- Check wether the table 'orders' contains any duplicate rows.
SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY ORDERID) AS TotalOrders
FROM
	Sales.Orders;

SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY ORDERID) AS TotalOrders
FROM
	Sales.OrdersArchive;

SELECT
	*
FROM
	(
		SELECT
			OrderID,
			COUNT(*) OVER(PARTITION BY ORDERID) AS TotalOrders
		FROM
			Sales.OrdersArchive
	)t where TotalOrders > 1;

/*
	Find the total sales across all orders
	and the total sales for each product.
	Additionally, provide details such as order ID and order date.
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() AS TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProductID
FROM
	Sales.Orders;

-- Find the percentage contribution of each product`s sales to the total sales.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS TotalSales,
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100, 2) AS PercentageOfSales
FROM
	Sales.Orders;

/*
	Find the average sales across all orders,
	And find the average sales for each product,
	Additionally provide details such order id, order date.
*/
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AS AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgSalesByProduct
FROM
	Sales.Orders;

/*
	Find the average scores of customers,
	Additionally provide details such customer id, last name.
*/
SELECT
	CustomerID,
	LastName,
	Score,
	AVG(COALESCE(Score, 0)) OVER() AS TotalScores
FROM
	Sales.Customers;

-- Find all orders where sales are higher than the average sales across all orders.
SELECT
	*
FROM
	(
		SELECT
			OrderID,
			ProductID,
			Sales,
			AVG(Sales) OVER() AS AvgSales
		FROM
			Sales.Orders
	)t
WHERE Sales > AvgSales;
	
























