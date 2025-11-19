USE SalesDB;

-- Rank the orders based on their sales from highest to lowest.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	ROW_NUMBER() OVER( ORDER BY Sales DESC) AS RowNumber_Ranking,
	RANK()		 OVER( ORDER BY Sales DESC) AS Rank_Ranking,
	DENSE_RANK() OVER( ORDER BY Sales DESC) AS DenseRank_Ranking
FROM
	Sales.Orders;

-- Find the top highest sales for each product.
SELECT
	*
FROM (
		SELECT
			*,
			ROW_NUMBER() OVER( PARTITION BY ProductID ORDER BY Sales ) AS Sales_Ranking
		FROM
			Sales.Orders
)T
WHERE Sales_Ranking = 1;

-- Find the top lowest customers based on their total sales.
SELECT
	*
FROM (
		SELECT
			CustomerID,
			SUM(Sales) TotalSales,
			ROW_NUMBER() OVER( ORDER BY SUM(Sales)) SalesRanking
		FROM
			Sales.Orders
		GROUP BY
			CustomerID
)T
WHERE
	SalesRanking <= 2;

-- Assign unique IDs to the rows of the 'Orders Archive' table.
SELECT
	ROW_NUMBER() OVER( ORDER BY OrderID ) UniqueID,
	*
FROM
	Sales.OrdersArchive;

/*
	Identify duplicate rows in the table 'Orders Archive'
	and return a clean result without any duplicates.
*/
SELECT
	*
FROM (
		SELECT
			*,
			RANK() OVER( PARTITION BY OrderID ORDER BY CreationTime DESC) RN 
		FROM
			Sales.OrdersArchive
)T
WHERE
	RN = 1;

-- Example for NTILE
SELECT
	OrderID,
	Sales,
	NTILE(1) OVER(ORDER BY Sales DESC) OneBuckets,
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBuckets,
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBuckets,
	NTILE(4) OVER(ORDER BY Sales DESC) FourBuckets
FROM
	Sales.Orders;

-- Segment all orders into 3 categories: High, Medium, and Low sales.
SELECT
	*,
	CASE
		WHEN Ranking = 1 THEN 'Low'
		WHEN Ranking = 2 THEN 'Medium'
		WHEN Ranking = 3 THEN 'High'
	END AS Categories
FROM (
		SELECT
			OrderID,
			Sales,
			NTILE(3) OVER( ORDER BY Sales) Ranking
		from
			Sales.Orders
)T

-- In order to export the data, divide the orders into 2 groups.
SELECT
	*,
	NTILE(2) OVER( ORDER BY OrderID ) AS Grouping
FROM
	Sales.Orders;

-- Find the products that fall within the highest 40% of the prices.
SELECT
	*,
	CONCAT(DistRank * 100, '%') AS DistRankPerc
FROM (
		SELECT
			*,
			CUME_DIST() OVER( ORDER BY Price ) AS DistRank
		FROM
			Sales.Products
)T
WHERE
	DistRank <= 0.4;

