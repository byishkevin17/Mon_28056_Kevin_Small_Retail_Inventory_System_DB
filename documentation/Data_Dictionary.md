# Data Dictionary: Retail Inventory System

| Table Name | Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- | :--- |
| **SUPPLIERS** | SUPPLIER_ID | NUMBER | PK | Unique ID for vendors |
| | SUPPLIER_NAME | VARCHAR2 | NOT NULL | Name of the supplier company |
| **PRODUCTS** | PRODUCT_ID | NUMBER | PK | Unique ID for inventory items |
| | QUANTITY | NUMBER | CHECK >= 0 | Current stock level |
| | PRICE | NUMBER | CHECK > 0 | Unit cost |
| **SALES** | SALE_ID | NUMBER | PK | Transaction ID |
| | SALE_DATE | DATE | DEFAULT SYSDATE | Time of purchase |