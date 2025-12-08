# Business Intelligence Requirements

## 1.  Stakeholders & Decision Support
* **Store Manager:** Needs daily sales reports to identify peak hours and best-selling items.
* **Inventory Manager:** Needs alerts for low-stock items to prevent stockouts (reordering).
* **Financial Auditor:** Needs total inventory valuation for asset reporting.

## 2.  Key Performance Indicators (KPIs)
The system tracks the following metrics to measure success:

| KPI Name | Definition | Calculation | Goal |
| :--- | :--- | :--- | :--- |
| **Stock Turnover Rate** | Frequency of stock depletion | `Total Sold / Avg Inventory` | High (Fast sales) |
| **Stockout Frequency** | Count of "DENIED" sales due to low stock | `COUNT(Audit_Log) WHERE Status='DENIED'` | Zero (0) |
| **Inventory Value** | Total capital tied up in stock | `SUM(Price * Quantity)` | Optimized |
| **Daily Sales Growth** | Sales vs. Previous Day | `(Today - Yesterday) / Yesterday %` | Positive Growth |

## 3.  Reporting Frequency
* **Real-time:** Low stock alerts (triggered instantly).
* **Daily:** Sales trends and revenue reports.
* **Monthly:** Supplier performance and full inventory audit.