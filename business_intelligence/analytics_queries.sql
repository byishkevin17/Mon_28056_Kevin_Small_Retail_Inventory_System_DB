-- ==========================================================
-- FILE: analytics_queries.sql
-- DESCRIPTION: BI Queries for Sales Trends and Inventory Value
-- ==========================================================

-- 1. DAILY SALES TREND (Growth Analysis)
-- Uses Window Functions to calculate running totals
SELECT 
    TO_CHAR(Sale_Date, 'YYYY-MM-DD') AS Sale_Day,
    SUM(Quantity_Sold) AS Daily_Total,
    SUM(SUM(Quantity_Sold)) OVER (ORDER BY TO_CHAR(Sale_Date, 'YYYY-MM-DD')) AS Running_Total
FROM Sales
GROUP BY TO_CHAR(Sale_Date, 'YYYY-MM-DD')
ORDER BY Sale_Day;

-- 2. TOTAL INVENTORY VALUATION
-- Calculates how much capital is tied up in stock
SELECT 
    SUM(Price * Quantity) AS Total_Asset_Value,
    COUNT(*) AS Total_Unique_Products
FROM Products;

-- 3. TOP SELLING PRODUCTS
-- Ranks products by popularity
SELECT 
    p.Product_Name,
    SUM(s.Quantity_Sold) AS Total_Sold
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sold DESC
FETCH FIRST 10 ROWS ONLY;