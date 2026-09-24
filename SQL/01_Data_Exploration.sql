-- =====================================================
-- Northwind SQL Analysis
-- 01 - Data Exploration
-- =====================================================

-- 1. Count total customers
SELECT COUNT(*) AS TotalCustomers
FROM Customers;


-- 2. Count total orders
SELECT COUNT(*) AS TotalOrders
FROM Orders;


-- 3. Count total products
SELECT COUNT(*) AS TotalProducts
FROM Products;


-- 4. Count total employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees;


-- 5. Find the earliest and latest order dates
SELECT 
    MIN(OrderDate) AS EarliestOrderDate,
    MAX(OrderDate) AS LatestOrderDate
FROM Orders;


-- 6. Check whether any orders are missing a CustomerID
SELECT COUNT(*) AS OrdersWithoutCustomer
FROM Orders
WHERE CustomerID IS NULL;


-- 7. Check for orders that have not been shipped
SELECT COUNT(*) AS UnshippedOrders
FROM Orders
WHERE ShippedDate IS NULL;