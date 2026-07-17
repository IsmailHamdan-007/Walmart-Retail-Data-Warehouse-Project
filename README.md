# 🛒 Walmart Retail Data Warehouse | SQL Server | Medallion Architecture

## 📌 Project Overview

This project demonstrates the design and implementation of an end-to-end Retail Data Warehouse using **SQL Server** and the **Medallion Architecture (Bronze, Silver, and Gold)**.

The primary objective is to transform raw Walmart retail data into a clean, analytics-ready warehouse by implementing ETL processes, data quality validation, dimensional modeling, and Star Schema design. The warehouse supports business reporting and analytical queries that help derive meaningful business insights.

---

# 🏗️ Architecture
                    CSV Files
                        │
                        ▼
               🥉 Bronze Layer
        (Raw Data Ingestion)
                        │
                        ▼
               🥈 Silver Layer
     (Data Cleaning & Transformation)
                        │
                        ▼
                 🥇 Gold Layer
      (Star Schema & Analytics Views)
                        │
                        ▼
          Business Analytics & Reporting
---

# 🎯 Project Objectives

- Build an end-to-end Data Warehouse using SQL Server
- Implement Medallion Architecture
- Develop ETL pipelines using Stored Procedures
- Perform comprehensive data quality validation
- Clean and standardize raw retail data
- Design analytical models using Star Schema
- Build reusable Gold Layer views
- Generate business insights using SQL

---

# 🛠️ Technologies Used

| Technology | Purpose |
|------------|----------|
| SQL Server | Data Warehouse |
| T-SQL | ETL & Analytics |
| SSMS | Development |
| Draw.io | Architecture Diagrams |
| Git & GitHub | Version Control |

---

# 📂 Project Structure

```
Walmart-Data-Warehouse
│
├── README.md
│
├── 01_Database_Setup
│      Create_Database.sql
│      Create_Schemas.sql
│
├── 02_Bronze_Layer
│      Bronze Tables.sql
│      Load_Bronze.sql
│
├── 03_Silver_Layer
│      Customers.sql
│      Employees.sql
│      Orders.sql
│      Order_Items.sql
│      Products.sql
│      Stores.sql
│
├── 04_Gold_Layer
│      Dim_Customers.sql
│      Dim_Products.sql
│      Dim_Stores.sql
│      Dim_Date.sql
│      Fact_Sales.sql
│
├── 05_Business_Queries
│
├── 06_Diagrams
│
└── 07_Screenshots
```

---

# 🥉 Bronze Layer

## Purpose

The Bronze Layer stores raw data exactly as received from the source files without any modifications.

### Responsibilities

- Raw CSV ingestion
- BULK INSERT
- Initial data loading
- Source data preservation
- Minimal transformations

### Tables

- Customers
- Employees
- Orders
- Order_Items
- Products
- Stores

---

# 🥈 Silver Layer

## Purpose

The Silver Layer transforms raw data into clean, standardized datasets suitable for analytics.

### Data Quality Checks

✔ Duplicate Removal
✔ NULL Handling
✔ Data Standardization
✔ Whitespace Removal
✔ Timestamp Validation
✔ Business Rule Validation
✔ Data Type Validation
✔ Active Record Filtering

### Transformations

- Trim spaces
- Remove duplicate records
- Validate timestamps
- Standardize values
- Clean text fields
- Apply business rules

---

# 🥇 Gold Layer

The Gold Layer is designed using a **Star Schema** to support analytical reporting.

## Dimension Views

- Dim_Customers
- Dim_Products
- Dim_Stores
- Dim_Date

## Fact View

- Fact_Sales

The Fact View combines transactional sales data with dimension keys, enabling efficient analytical queries.
---
# ⭐ Star Schema

                 Dim_Customers
                        │
                        │
                        ▼
                  Fact_Sales
          ▲         ▲        ▲
          │         │        │
Dim_Products   Dim_Date   Dim_Stores
---

# 🔄 ETL Workflow

CSV Files
↓
Bronze Layer
↓
Data Validation
↓
Silver Layer
↓
Business Transformations
↓
Gold Layer
↓
Business Analytics

---

# 📊 Business Analytics

The Data Warehouse supports analytical queries such as:

- Total Revenue
- Monthly Sales
- Quarterly Sales
- Top Selling Products
- Revenue by Category
- Store Performance
- Customer Revenue Analysis
- Product Rankings
- Revenue Contribution
- Running Totals
- Window Functions
- Customer Segmentation

---

# 📈 SQL Concepts Demonstrated

- Joins
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- Aggregate Functions
- CASE Statements
- Views
- Stored Procedures
- TRY...CATCH
- BULK INSERT
- Data Cleaning
- ETL Development
- Star Schema
- Dimensional Modeling

---

# 📋 Data Quality Validation

Implemented validations include:

- Duplicate Detection
- NULL Value Checks
- Timestamp Consistency
- Invalid Records
- Business Rule Validation
- Data Standardization
- Referential Integrity Checks

---

# 📷 Project Screenshots

Include screenshots of:

- SQL Server Database
- Bronze Tables
- Silver Tables
- Gold Views
- Star Schema
- Medallion Architecture
- Business Query Results

---

# 🚀 Key Learnings

Through this project I gained practical experience in:

- Data Warehouse Design
- ETL Development
- SQL Programming
- Data Cleaning
- Data Modeling
- Star Schema Design
- Medallion Architecture
- Analytical SQL
- Business Intelligence Concepts
- GitHub Project Documentation

---

# 📌 Future Enhancements

- Implement Incremental Loading
- Slowly Changing Dimensions (SCD)
- PySpark Implementation
- Delta Lake
- Databricks
- Azure Data Factory
- Microsoft Fabric
- Automated Scheduling
- Cloud Data Warehouse

---

# 👨‍💻 Author

**Ismail Hamdan**

Aspiring Data Engineer

LinkedIn: https://www.linkedin.com/in/ismailnhamdan?utm_source=share_via&utm_content=profile&utm_medium=member_android

GitHub: https://github.com/IsmailHamdan-007/

---

# ⭐ If you found this project useful, feel free to star the repository.
