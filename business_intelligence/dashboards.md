# BI Dashboards & Reports

## 1. Executive Summary Dashboard
**Purpose:** Provides a high-level view of store performance.

### A. Daily Sales Trend
*Query used:* `SELECT Sale_Date, SUM(Qty) OVER (ORDER BY Date)...`
*(Screenshot of your SQL Developer query result for Sales Trend goes here)*

### B. Top 5 Best-Selling Products
*Query used:* `SELECT Product_Name, COUNT(*) FROM Sales...`
*(Screenshot of your SQL Developer query result for Top Products goes here)*

---

## 2. Operational Dashboard (Stock Alerts)
**Purpose:** Instant action list for the Inventory Manager.

### A. Low Stock Alert List
*Logic:* Lists all products where `check_stock_status(id) = 'LOW_STOCK'`.
*(Screenshot of your SQL Developer output showing low stock items)*