-- =====================================================
-- Northwind SQL Analysis
-- 02 - Revenue Analysis
-- =====================================================


-- 1. Calculate total revenue
-- Revenue = UnitPrice * Quantity * (1 - Discount)

SELECT 
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalRevenue
FROM [Order Details];


-- 2. Calculate revenue for each order

SELECT
    OrderID,
    ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS OrderRevenue
FROM [Order Details]
GROUP BY OrderID
ORDER BY OrderRevenue DESC;


-- 3. Calculate Average Order Value (AOV)

WITH OrderRevenue AS (
    SELECT
        OrderID,
        SUM(UnitPrice * Quantity * (1 - Discount)) AS Revenue
    FROM [Order Details]
    GROUP BY OrderID
)
SELECT
    ROUND(AVG(Revenue), 2) AS AverageOrderRevenue
FROM OrderRevenue;


-- 4. Calculate annual revenue

SELECT
    YEAR(o.OrderDate) AS OrderYear,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Orders o
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY OrderYear;


-- 5. Calculate monthly revenue

SELECT
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Orders o
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 6. Calculate monthly revenue with a month label

SELECT
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    DATENAME(MONTH, o.OrderDate) AS MonthName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Orders o
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    MONTH(o.OrderDate),
    DATENAME(MONTH, o.OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;




-- 7. Calculate revenue by year and month using a CTE
-- This provides a clean summary for further analysis.

WITH MonthlyRevenue AS (
    SELECT
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Revenue
    FROM Orders o
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
)

SELECT
    OrderYear,
    OrderMonth,
    ROUND(Revenue, 2) AS Revenue
FROM MonthlyRevenue
ORDER BY
    OrderYear,
    OrderMonth;