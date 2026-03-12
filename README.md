# 🏢 Data Warehouse Project

A fully structured SQL-based Data Warehouse using a **Star Schema** design, built for retail sales analytics.

## 📐 Architecture

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
              ┌─────────│ discount_amount  │─────────┐
              │         │ total_amount     │         │
         ┌────▼──────┐  └─────────────────┘  ┌──────▼─────┐
         │DIM_CUSTOMER│                       │DIM_PRODUCT │
         └────────────┘                       └────────────┘
```

## 📁 Project Structure

```
data-warehouse-project/
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

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 13+ or MySQL 8+
- SQL client (DBeaver, pgAdmin, MySQL Workbench)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/data-warehouse-project.git
cd data-warehouse-project

# 2. Run setup script
bash scripts/setup.sh

# Or manually run SQLs in order:
psql -U your_user -d your_db -f sql/ddl/01_create_dimensions.sql
psql -U your_user -d your_db -f sql/ddl/02_create_fact_tables.sql
psql -U your_user -d your_db -f sql/dml/01_load_dimensions.sql
psql -U your_user -d your_db -f sql/dml/02_load_facts.sql
psql -U your_user -d your_db -f sql/indexes/idx_performance.sql
psql -U your_user -d your_db -f sql/views/vw_sales_analysis.sql
psql -U your_user -d your_db -f sql/stored_procedures/sp_load_sales.sql
```

## 📊 Key Features

- ⭐ **Star Schema** design for fast analytical queries
- 🗓️ **Date Dimension** with full calendar hierarchy
- 👥 **Customer Dimension** with demographics & segmentation
- 📦 **Product Dimension** with category hierarchy
- 🏪 **Store Dimension** with geographic hierarchy
- 💰 **Fact Sales** table with pre-aggregated metrics
- 🔄 **ETL Pipeline** for incremental loads
- 📈 **Analytical Views** for common reporting needs
- ⚡ **Optimized Indexes** for query performance

## 🧮 Sample Queries

```sql
-- Monthly revenue by product category
SELECT d.year, d.month_name, p.category, SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY d.year, d.month_name, p.category
ORDER BY d.year, d.month_num;

-- Top 10 customers by lifetime value
SELECT c.full_name, c.segment, SUM(f.total_amount) AS lifetime_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.full_name, c.segment
ORDER BY lifetime_value DESC
LIMIT 10;
```

## 📄 License
MIT
