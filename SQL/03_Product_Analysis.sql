-- =====================================================
-- Northwind SQL Analysis
-- 03 - Product Analysis
-- =====================================================


-- 1. Calculate total revenue by product

SELECT
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Products p
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;


-- 2. Identify the top 10 products by revenue

SELECT TOP 10
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Products p
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;


-- 3. Calculate revenue by category

SELECT
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue
FROM Categories c
INNER JOIN Products p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY Revenue DESC;


-- 4. Calculate total units sold by product

SELECT
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold
FROM Products p
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC;


-- 5. Identify the top 10 products by units sold

SELECT TOP 10
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold
FROM Products p
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC;


-- 6. Compare product revenue and units sold

SELECT
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS Revenue
FROM Products p
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;