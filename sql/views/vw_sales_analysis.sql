-- ============================================================
-- DATA WAREHOUSE - ANALYTICAL VIEWS
-- ============================================================

-- ============================================================
-- VIEW 1: Sales Summary with all dimension details
-- ============================================================
CREATE OR REPLACE VIEW vw_sales_detail AS
SELECT
    f.sale_id,
    f.order_id,
    f.order_line_num,
    -- Date attributes
    d.full_date         AS sale_date,
    d.day_name,
    d.month_name,
    d.quarter_name,
    d.year,
    d.is_weekend,
    -- Customer attributes
    c.customer_id,
    c.full_name         AS customer_name,
    c.segment           AS customer_segment,
    c.city              AS customer_city,
    c.state             AS customer_state,
    -- Product attributes
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    -- Store attributes
    s.store_id,
    s.store_name,
    s.store_type,
    s.city              AS store_city,
    s.region,
    -- Measures
    f.quantity_sold,
    f.unit_price,
    f.unit_cost,
    f.discount_pct,
    f.discount_amount,
    f.tax_amount,
    f.gross_amount,
    f.net_amount,
    f.total_amount,
    f.profit_amount,
    f.sale_channel,
    f.payment_method
FROM fact_sales f
JOIN dim_date     d ON f.date_key     = d.date_key
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_product  p ON f.product_key  = p.product_key
JOIN dim_store    s ON f.store_key    = s.store_key;

COMMENT ON VIEW vw_sales_detail IS 'Full denormalized sales view joining all dimensions';

-- ============================================================
-- VIEW 2: Monthly Revenue by Category
-- ============================================================
CREATE OR REPLACE VIEW vw_monthly_revenue_by_category AS
SELECT
    d.year,
    d.month_num,
    d.month_name,
    p.category,
    p.sub_category,
    COUNT(DISTINCT f.order_id)  AS total_orders,
    SUM(f.quantity_sold)        AS total_units,
    SUM(f.gross_amount)         AS gross_revenue,
    SUM(f.discount_amount)      AS total_discounts,
    SUM(f.total_amount)         AS net_revenue,
    SUM(f.profit_amount)        AS total_profit,
    ROUND(SUM(f.profit_amount) / NULLIF(SUM(f.net_amount), 0) * 100, 2) AS profit_margin_pct
FROM fact_sales f
JOIN dim_date    d ON f.date_key    = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY d.year, d.month_num, d.month_name, p.category, p.sub_category;

COMMENT ON VIEW vw_monthly_revenue_by_category IS 'Monthly revenue breakdown by product category';

-- ============================================================
-- VIEW 3: Customer Lifetime Value & Segmentation
-- ============================================================
CREATE OR REPLACE VIEW vw_customer_ltv AS
SELECT
    c.customer_id,
    c.full_name,
    c.segment,
    c.city,
    c.state,
    COUNT(DISTINCT f.order_id)          AS total_orders,
    SUM(f.quantity_sold)                AS total_items,
    SUM(f.total_amount)                 AS lifetime_value,
    AVG(f.total_amount)                 AS avg_order_value,
    MIN(d.full_date)                    AS first_purchase_date,
    MAX(d.full_date)                    AS last_purchase_date,
    MAX(d.full_date) - MIN(d.full_date) AS customer_tenure_days
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_date     d ON f.date_key     = d.date_key
GROUP BY c.customer_id, c.full_name, c.segment, c.city, c.state;

COMMENT ON VIEW vw_customer_ltv IS 'Customer lifetime value and purchase behaviour metrics';

-- ============================================================
-- VIEW 4: Store Performance Dashboard
-- ============================================================
CREATE OR REPLACE VIEW vw_store_performance AS
SELECT
    s.store_id,
    s.store_name,
    s.store_type,
    s.city,
    s.region,
    d.year,
    d.month_num,
    d.month_name,
    COUNT(DISTINCT f.order_id)  AS orders,
    SUM(f.quantity_sold)        AS units_sold,
    SUM(f.total_amount)         AS revenue,
    SUM(f.profit_amount)        AS profit,
    ROUND(SUM(f.profit_amount) / NULLIF(SUM(f.total_amount), 0) * 100, 2) AS profit_pct
FROM fact_sales f
JOIN dim_store  s ON f.store_key = s.store_key
JOIN dim_date   d ON f.date_key  = d.date_key
GROUP BY s.store_id, s.store_name, s.store_type, s.city, s.region, d.year, d.month_num, d.month_name;

COMMENT ON VIEW vw_store_performance IS 'Monthly store performance metrics';

-- ============================================================
-- VIEW 5: Top Products by Revenue
-- ============================================================
CREATE OR REPLACE VIEW vw_top_products AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    COUNT(DISTINCT f.order_id)  AS times_ordered,
    SUM(f.quantity_sold)        AS total_units_sold,
    SUM(f.total_amount)         AS total_revenue,
    SUM(f.profit_amount)        AS total_profit,
    ROUND(AVG(f.discount_pct), 2) AS avg_discount_pct,
    RANK() OVER (ORDER BY SUM(f.total_amount) DESC) AS revenue_rank
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_id, p.product_name, p.category, p.brand;

COMMENT ON VIEW vw_top_products IS 'Product performance ranked by total revenue';
