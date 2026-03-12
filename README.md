# 🏢 Retail Sales Data Warehouse

A end-to-end Data Warehouse project built using **SQL Server**, designed to analyze retail sales data through a clean **Star Schema** architecture. This project covers data modeling, ETL processes, stored procedures, analytical views, and performance optimization.

---

## 👨‍💻 About This Project

Hi, I'm **Chintan D S**, a fresher passionate about data analytics and data engineering. I built this project to strengthen my understanding of data warehouse concepts and demonstrate my skills in SQL Server, Python, and Power BI.

This project simulates a real-world retail sales analytics system — from raw data ingestion to business-ready reporting layers.

---

## 📐 Architecture — Star Schema

```
                        ┌─────────────────┐
                        │   FACT_SALES     │
                        │─────────────────│
              ┌─────────│ sale_id (PK)     │─────────┐
              │         │ date_key (FK)    │         │
              │         │ customer_key(FK) │         │
         ┌────▼────┐    │ product_key (FK) │   ┌─────▼────┐
         │DIM_DATE │    │ store_key (FK)   │   │DIM_STORE │
         └─────────┘    │ quantity_sold    │   └──────────┘
                        │ unit_price       │
              ┌─────────│ total_amount     │─────────┐
              │         └─────────────────┘         │
         ┌────▼──────┐                      ┌───────▼────┐
         │DIM_CUSTOMER│                     │DIM_PRODUCT │
         └────────────┘                     └────────────┘
```

---

## 📁 Project Structure

```
warehouse_prj/
├── sql/
│   ├── ddl/                  # Table definitions (CREATE statements)
│   │   ├── 01_create_dimensions.sql
│   │   └── 02_create_fact_tables.sql
│   ├── dml/                  # Sample data (INSERT statements)
│   │   ├── 01_load_dimensions.sql
│   │   └── 02_load_facts.sql
│   ├── etl/                  # ETL pipeline scripts
│   │   └── etl_pipeline.sql
│   ├── stored_procedures/    # Reusable procedures
│   │   └── sp_load_sales.sql
│   ├── views/                # Analytical views
│   │   └── vw_sales_analysis.sql
│   └── indexes/              # Performance indexes
│       └── idx_performance.sql
├── docs/
│   └── data_dictionary.md
├── scripts/
│   └── setup.sh
└── README.md
```

---

## 🛠️ Tech Stack

| Tool | Usage |
|------|-------|
| **SQL Server** | Core database, DDL, DML, stored procedures |
| **Python** | Data preparation and automation scripts |
| **Power BI** | Dashboard and visualization layer |

---

## ✨ Key Features

- ⭐ **Star Schema** design for fast analytical queries
- 🗓️ **Date Dimension** with full calendar hierarchy (2023–2025)
- 👥 **Customer Dimension** with SCD Type 2 for tracking history
- 📦 **Product Dimension** with category hierarchy & profit margin
- 🏪 **Store Dimension** with regional geographic hierarchy
- 💰 **Fact Sales** table with pre-calculated financial metrics
- 🔄 **ETL Pipeline** with staging table & incremental load support
- 📈 **5 Analytical Views** for common reporting needs
- ⚡ **15 Optimized Indexes** for query performance
- 🧰 **Stored Procedure** for automated sales data loading

---

## 🚀 Getting Started

### Prerequisites
- SQL Server 2019+ or PostgreSQL 13+
- SQL client (SSMS, DBeaver, or pgAdmin)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/CHINTANDS26/warehouse_prj.git
cd warehouse_prj

# 2. Run SQLs in order:
-- Step 1: Create dimension tables
-- Step 2: Create fact tables
-- Step 3: Create indexes
-- Step 4: Load sample data
-- Step 5: Create views & stored procedures
```

---

## 📊 Sample Analytical Queries

```sql
-- Monthly revenue by product category
SELECT d.year, d.month_name, p.category,
       SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_date d    ON f.date_key    = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY d.year, d.month_name, p.category
ORDER BY d.year, d.month_num;

-- Top 10 customers by lifetime value
SELECT c.full_name, c.segment,
       SUM(f.total_amount) AS lifetime_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.full_name, c.segment
ORDER BY lifetime_value DESC
LIMIT 10;

-- Store-wise profit margin
SELECT s.store_name, s.region,
       ROUND(SUM(f.profit_amount) / SUM(f.total_amount) * 100, 2) AS profit_pct
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY s.store_name, s.region
ORDER BY profit_pct DESC;
```

---

## 📚 What I Learned

- Designing a **Star Schema** from scratch for analytical workloads
- Writing optimized **SQL queries** with joins across multiple dimensions
- Building **ETL pipelines** with staging tables and incremental loads
- Implementing **SCD Type 2** for slowly changing dimensions
- Creating **stored procedures** for automated and reusable data loading
- Performance tuning with **indexes** on fact and dimension tables

---

## 📬 Connect With Me

- 🐙 GitHub: [CHINTANDS26](https://github.com/CHINTANDS26)

---

## 📄 License
MIT — feel free to use and learn from this project!
