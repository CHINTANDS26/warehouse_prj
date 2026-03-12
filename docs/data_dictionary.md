# 📚 Data Dictionary - Retail Sales Data Warehouse

## Overview
This data warehouse uses a **Star Schema** design optimized for retail sales analytics. The schema consists of 4 dimension tables and 1 core fact table, plus 1 aggregate fact table.

---

## Dimension Tables

### `dim_date`
| Column | Type | Description |
|--------|------|-------------|
| date_key | INT (PK) | Surrogate key in YYYYMMDD format |
| full_date | DATE | Actual calendar date |
| day_of_week | SMALLINT | 1=Sunday, 7=Saturday |
| day_name | VARCHAR | Full day name (Monday, Tuesday...) |
| month_num | SMALLINT | Month number 1–12 |
| month_name | VARCHAR | Full month name |
| quarter | SMALLINT | Quarter number 1–4 |
| year | SMALLINT | Calendar year |
| is_weekend | BOOLEAN | TRUE if Saturday or Sunday |
| is_holiday | BOOLEAN | TRUE if national/regional holiday |

---

### `dim_customer`
| Column | Type | Description |
|--------|------|-------------|
| customer_key | SERIAL (PK) | Surrogate key |
| customer_id | VARCHAR | Business/natural key |
| full_name | VARCHAR | Generated: first_name + last_name |
| gender | CHAR(1) | M=Male, F=Female, O=Other |
| age_group | VARCHAR | Age bracket (18-25, 26-35, etc.) |
| segment | VARCHAR | Bronze / Silver / Gold / Platinum |
| loyalty_points | INT | Accumulated loyalty points |
| is_current | BOOLEAN | SCD Type 2 - current record flag |
| effective_date | DATE | SCD Type 2 - record start date |
| expiry_date | DATE | SCD Type 2 - record end date (9999-12-31 if current) |

---

### `dim_product`
| Column | Type | Description |
|--------|------|-------------|
| product_key | SERIAL (PK) | Surrogate key |
| product_id | VARCHAR | Business/natural key |
| category | VARCHAR | Top-level category (Electronics, Apparel...) |
| sub_category | VARCHAR | Second-level category |
| brand | VARCHAR | Product brand name |
| unit_cost | NUMERIC | Cost price |
| unit_price | NUMERIC | Selling price |
| profit_margin_pct | NUMERIC | Generated: (price-cost)/price × 100 |
| tax_rate_pct | NUMERIC | GST/tax rate (default 18%) |
| is_current | BOOLEAN | SCD Type 2 - current record flag |

---

### `dim_store`
| Column | Type | Description |
|--------|------|-------------|
| store_key | SERIAL (PK) | Surrogate key |
| store_id | VARCHAR | Business/natural key |
| store_type | VARCHAR | Flagship / Express / Online |
| region | VARCHAR | North / South / East / West / Pan-India |
| zone | VARCHAR | Sub-region zone |
| floor_area_sqft | INT | Physical store size (0 for Online) |

---

## Fact Tables

### `fact_sales` *(Grain: one row per order line item)*
| Column | Type | Description |
|--------|------|-------------|
| sale_id | BIGSERIAL (PK) | Surrogate key |
| date_key | INT (FK) | Links to dim_date |
| customer_key | INT (FK) | Links to dim_customer |
| product_key | INT (FK) | Links to dim_product |
| store_key | INT (FK) | Links to dim_store |
| order_id | VARCHAR | Degenerate dimension - Order reference |
| quantity_sold | INT | Number of units sold |
| unit_price | NUMERIC | Selling price at time of sale |
| unit_cost | NUMERIC | Cost price at time of sale |
| discount_pct | NUMERIC | Discount percentage applied |
| discount_amount | NUMERIC | Calculated: gross × discount_pct/100 |
| tax_amount | NUMERIC | GST/tax charged |
| gross_amount | NUMERIC | qty × unit_price |
| net_amount | NUMERIC | gross_amount − discount_amount |
| total_amount | NUMERIC | net_amount + tax_amount |
| profit_amount | NUMERIC | net_amount − (qty × unit_cost) |
| sale_channel | VARCHAR | In-Store / Online / Phone |
| payment_method | VARCHAR | Cash / Card / UPI / EMI |

---

### `fact_sales_monthly_agg` *(Pre-aggregated for fast dashboards)*
| Column | Type | Description |
|--------|------|-------------|
| year | SMALLINT | Calendar year |
| month_num | SMALLINT | Month number |
| product_key | INT (FK) | Links to dim_product |
| store_key | INT (FK) | Links to dim_store |
| total_orders | INT | Count of distinct orders |
| total_quantity | INT | Sum of units sold |
| total_net_amount | NUMERIC | Sum of net revenue |
| total_profit | NUMERIC | Sum of profit |
| avg_order_value | NUMERIC | Average order total |

---

## ETL Flow
```
Source Systems → stg_sales_raw (Staging) → fn_etl_process_staging() → fact_sales → sp_refresh_monthly_agg()
```

## Naming Conventions
- Tables: `snake_case` with prefixes: `dim_`, `fact_`, `stg_`, `vw_`
- Surrogate keys: `table_name_key` (e.g., `customer_key`)
- Business keys: `table_name_id` (e.g., `customer_id`)
- Boolean flags: `is_` prefix (e.g., `is_active`, `is_current`)
- Timestamps: `_at` suffix (e.g., `created_at`, `updated_at`)
