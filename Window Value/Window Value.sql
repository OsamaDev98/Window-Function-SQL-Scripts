USE SalesDB;

/*
	Analyze the month-to-month performance by finding the percentage change
	in sales between the current and previous months.
*/
SELECT
	*,
	CurrentMonthSales - PreviousMonthSales,
	CONCAT(
		ROUND(
			COALESCE(
				CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT),
				0)
		/ PreviousMonthSales * 100, 2),
	'%'
	) AS MOM_Change
FROM (
	SELECT
		MONTH(OrderDate) AS OrderMonth,
		SUM(Sales) AS CurrentMonthSales,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
	FROM
		Sales.Orders
	GROUP BY
		MONTH(OrderDate)
)T;

/*
	In order to analyze customer loyalty,
	rank customers based on the average days between their orders.
*/
SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AS AvgDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999999)) AS RankAvg
FROM
	(
		SELECT
			OrderID,
			CustomerID,
			OrderDate AS CurrentOrder,
			LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
			DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS DaysUntilNextOrder
		FROM
			Sales.Orders
)T
GROUP BY
	CustomerID;

-- Find the lowest and highest sales for each product.
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestValue,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS HighestValue,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS HighestValue2
FROM
	Sales.Orders;

SELECT
	ProductID,
	MIN(Sales) AS LowestValue,
	MAX(Sales) AS HighestValue
FROM
	Sales.Orders
GROUP BY
	ProductID;

/*
	Find the lowest and highest sales for each product,
	Find the difference in sales between the current and the lowest sales.
*/
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestValue,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS HighestValue,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM
	Sales.Orders;























