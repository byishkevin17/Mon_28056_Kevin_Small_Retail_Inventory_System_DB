# Smart Retail Inventory System (Oracle PL/SQL Capstone)

**Student Name:** Kevin  
**Student ID:** 28056  
**Group:** Monday (MON)  
**Course:** INSY 8311 - Database Development with PL/SQL  
**Lecturer:** Eric Maniraguha  
**Institution:** Adventist University of Central Africa (AUCA)

---

##  Project Overview
The **Smart Retail Inventory System** is a robust Oracle Database solution designed to modernize inventory tracking for small retail businesses. By replacing manual, paper-based records with a centralized PL/SQL-driven architecture, this system ensures real-time stock accuracy, automates sales transactions, and enforces strict security protocols.

This project was built as a comprehensive Capstone assignment demonstrating mastery of **Advanced PL/SQL** concepts including Stored Procedures, Triggers, Packages, and Business Intelligence (BI) analytics.

##  Problem Statement
Small retail shops currently face significant operational risks due to manual record-keeping:
* **Stockouts:** High-demand items run out without warning, leading to lost revenue.
* **Data Lag:** Inventory records are updated days after sales occur, creating "ghost inventory."
* **Security Vulnerabilities:** Unauthorized staff can modify stock levels at any time without a digital footprint.

**Solution:** This database automates the "Sale-to-Inventory" lifecycle, deducting stock immediately upon purchase and blocking unauthorized modifications during weekends/holidays via automated triggers.

##  Key Objectives
1.  **Automation:** Implement `register_sale` procedures to handle transactions and inventory updates atomically.
2.  **Data Integrity:** Use Foreign Keys and Constraints to ensure valid relationships between Suppliers, Products, and Sales.
3.  **Security:** Deploy `trg_audit_products` to restrict DML operations to authorized hours only (Weekends/Holidays rule).
4.  **Auditing:** Capture every system interaction in an `AUDIT_LOG` using an autonomous PL/SQL package.

---

##  Repository Structure
This repository matches the required Capstone folder structure:

* **`database/scripts/`**: Contains the main `MON_28056_FULL_SCRIPT.sql` (Tables + Data).
* **`database/objects/`**: PL/SQL Packages (`audit_pkg`), Procedures, and Functions.
* **`documentation/`**:
    * `PhaseI_Problem.pptx`: Problem Identification Presentation.
    * `PhaseII_Process.pdf`: Business Process Swimlane Diagrams.
    * `ERD_Diagram.png`: Entity Relationship Diagram.
    * `Data_Dictionary.md`: Detailed metadata of all tables.
* **`business_intelligence/`**: Analytical queries for sales trends and inventory valuation.
* **`screenshots/`**: Evidence of successful test runs and OEM monitoring.

---

##  Quick Start Guide
Follow these steps to deploy the system on a local Oracle 19c/21c environment.

### Step 1: Create the Database Container
Run this as the **SYS/Admin** user to set up the Pluggable Database (PDB).

```sql
-- Create PDB and Developer User
CREATE PLUGGABLE DATABASE MON_28056_KEVIN_INVENTORY_DB
ADMIN USER AdminKevin IDENTIFIED BY Kevin
FILE_NAME_CONVERT = ('/pdbseed/', '/MON_28056_KEVIN_INVENTORY_DB/');

ALTER PLUGGABLE DATABASE MON_28056_KEVIN_INVENTORY_DB OPEN;
ALTER PLUGGABLE DATABASE MON_28056_KEVIN_INVENTORY_DB SAVE STATE;

ALTER SESSION SET CONTAINER = MON_28056_KEVIN_INVENTORY_DB;

CREATE USER kevin_dev IDENTIFIED BY Kevin123;
GRANT CONNECT, RESOURCE, DBA TO kevin_dev;

**### Step 2: Deploy the Schema**
Open SQL Developer.

Connect as kevin_dev (Password: Kevin123).

Run the script located in: database/scripts/MON_28056_FULL_SCRIPT.sql.

**### Step 3: Verify & Test**
Run the following checks to confirm the installation:
-- 1. Verify Data Generation (Should show 400+ rows)
SELECT COUNT(*) FROM Products;

-- 2. Test Security Trigger (Should fail on Mon-Fri)
UPDATE Products SET Quantity = 500 WHERE Product_ID = 1;

-- 3. View Audit Trail
SELECT * FROM audit_log ORDER BY action_date DESC;

Business Intelligence Features
The system includes built-in analytics functions:

get_inventory_value(): Calculates total capital tied up in stock.

Sales Trend Analysis: Uses Window Functions (LAG, LEAD) to compare daily sales performance.

Stock Alerts: check_stock_status() function instantly flags items below reorder thresholds.

© 2025 Kevin (ID: 28056) | Adventist University of Central Africa

