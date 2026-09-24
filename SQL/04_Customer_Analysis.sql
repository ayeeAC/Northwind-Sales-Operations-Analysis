-- =====================================================
-- Northwind SQL Analysis
-- 04 - Customer Analysis
-- =====================================================


-- 1. Calculate total revenue by customer

SELECT
    c.CustomerID,
    c.CompanyName,
    c.Country,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS Revenue
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName,
    c.Country
ORDER BY Revenue DESC;


-- 2. Identify the top 10 customers by revenue

SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    c.Country,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS Revenue
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName,
    c.Country
ORDER BY Revenue DESC;


-- 3. Calculate number of orders per customer

SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY OrderCount DESC;


-- 4. Calculate Average Order Value (AOV) by customer

WITH CustomerOrderRevenue AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        c.CompanyName,
        o.OrderID
)

SELECT
    CustomerID,
    CompanyName,
    COUNT(OrderID) AS OrderCount,
    ROUND(AVG(OrderRevenue), 2) AS AverageOrderValue
FROM CustomerOrderRevenue
GROUP BY
    CustomerID,
    CompanyName
ORDER BY AverageOrderValue DESC;


-- 5. Create customer AOV tiers using CASE

WITH CustomerOrderRevenue AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        c.CompanyName,
        o.OrderID
),
CustomerAOV AS (
    SELECT
        CustomerID,
        CompanyName,
        AVG(OrderRevenue) AS AverageOrderValue
    FROM CustomerOrderRevenue
    GROUP BY
        CustomerID,
        CompanyName
)

SELECT
    CustomerID,
    CompanyName,
    ROUND(AverageOrderValue, 2) AS AverageOrderValue,
    CASE
        WHEN AverageOrderValue >= 3000 THEN 'High Value'
        WHEN AverageOrderValue >= 1500 THEN 'Medium'
        ELSE 'Standard'
    END AS CustomerTier
FROM CustomerAOV
ORDER BY AverageOrderValue DESC;


-- 6. Create customer revenue tiers using CASE

WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS Revenue
    FROM Customers c
    INNER JOIN Orders o
        ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        c.CompanyName
)

SELECT
    CustomerID,
    CompanyName,
    ROUND(Revenue, 2) AS Revenue,
    CASE
        WHEN Revenue >= 50000 THEN 'Top Performer'
        WHEN Revenue >= 20000 THEN 'Strong Performer'
        ELSE 'Standard'
    END AS RevenueTier
FROM CustomerRevenue
ORDER BY Revenue DESC;