-- =====================================================
-- Northwind SQL Analysis
-- 05 - Employee Analysis
-- =====================================================


-- 1. Calculate total revenue by employee

SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS Revenue
FROM Employees e
INNER JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY Revenue DESC;


-- 2. Calculate number of orders handled by each employee

SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(o.OrderID) AS OrderCount
FROM Employees e
LEFT JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY OrderCount DESC;


-- 3. Calculate average order revenue by employee

WITH EmployeeOrderRevenue AS (
    SELECT
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        o.OrderID,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderRevenue
    FROM Employees e
    INNER JOIN Orders o
        ON e.EmployeeID = o.EmployeeID
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        o.OrderID
)

SELECT
    EmployeeID,
    EmployeeName,
    COUNT(OrderID) AS OrderCount,
    ROUND(AVG(OrderRevenue), 2) AS AverageOrderRevenue
FROM EmployeeOrderRevenue
GROUP BY
    EmployeeID,
    EmployeeName
ORDER BY AverageOrderRevenue DESC;


-- 4. Calculate annual revenue by employee

SELECT
    YEAR(o.OrderDate) AS OrderYear,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS Revenue
FROM Employees e
INNER JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    e.FirstName,
    e.LastName
ORDER BY
    OrderYear,
    Revenue DESC;


-- 5. Rank employees by revenue within each year

WITH EmployeeRevenue AS (
    SELECT
        YEAR(o.OrderDate) AS OrderYear,
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS Revenue
    FROM Employees e
    INNER JOIN Orders o
        ON e.EmployeeID = o.EmployeeID
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        YEAR(o.OrderDate),
        e.EmployeeID,
        e.FirstName,
        e.LastName
)

SELECT
    OrderYear,
    EmployeeName,
    ROUND(Revenue, 2) AS Revenue,
    RANK() OVER (
        PARTITION BY OrderYear
        ORDER BY Revenue DESC
    ) AS RevenueRank
FROM EmployeeRevenue
ORDER BY
    OrderYear,
    RevenueRank;