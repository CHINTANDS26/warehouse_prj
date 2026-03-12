-- ============================================================
-- DATA WAREHOUSE - FACT TABLES
-- ============================================================

-- ============================================================
-- FACT_SALES - Core Sales Fact Table
-- ============================================================
CREATE TABLE fact_sales (
    sale_id             BIGSERIAL       PRIMARY KEY,
    -- Foreign Keys (Dimension Links)
    date_key            INT             NOT NULL REFERENCES dim_date(date_key),
    customer_key        INT             NOT NULL REFERENCES dim_customer(customer_key),
    product_key         INT             NOT NULL REFERENCES dim_product(product_key),
    store_key           INT             NOT NULL REFERENCES dim_store(store_key),
    -- Degenerate Dimensions (no separate table needed)
    order_id            VARCHAR(30)     NOT NULL,
    order_line_num      SMALLINT        NOT NULL DEFAULT 1,
    invoice_number      VARCHAR(30),
    -- Measures
    quantity_sold       INT             NOT NULL DEFAULT 1,
    unit_price          NUMERIC(12, 2)  NOT NULL,
    unit_cost           NUMERIC(12, 2)  NOT NULL,
    discount_pct        NUMERIC(5, 2)   NOT NULL DEFAULT 0,
    discount_amount     NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    gross_amount        NUMERIC(12, 2)  NOT NULL,         -- qty * unit_price
    net_amount          NUMERIC(12, 2)  NOT NULL,         -- gross - discount
    total_amount        NUMERIC(12, 2)  NOT NULL,         -- net + tax
    profit_amount       NUMERIC(12, 2)  NOT NULL,         -- net - (qty * unit_cost)
    -- Metadata
    sale_channel        VARCHAR(20),                      -- In-Store, Online, Phone
    payment_method      VARCHAR(30),                      -- Cash, Card, UPI, etc.
    return_flag         BOOLEAN         NOT NULL DEFAULT FALSE,
    return_date_key     INT             REFERENCES dim_date(date_key),
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE fact_sales IS 'Grain: one row per order line item. Central fact table for sales analytics.';

-- ============================================================
-- FACT_SALES_MONTHLY_AGG - Pre-aggregated Monthly Summary
-- (Aggregate Fact Table for faster reporting)
-- ============================================================
CREATE TABLE fact_sales_monthly_agg (
    agg_id              BIGSERIAL       PRIMARY KEY,
    year                SMALLINT        NOT NULL,
    month_num           SMALLINT        NOT NULL,
    product_key         INT             NOT NULL REFERENCES dim_product(product_key),
    store_key           INT             NOT NULL REFERENCES dim_store(store_key),
    -- Aggregated Measures
    total_orders        INT             NOT NULL DEFAULT 0,
    total_quantity      INT             NOT NULL DEFAULT 0,
    total_gross_amount  NUMERIC(15, 2)  NOT NULL DEFAULT 0,
    total_discount      NUMERIC(15, 2)  NOT NULL DEFAULT 0,
    total_tax           NUMERIC(15, 2)  NOT NULL DEFAULT 0,
    total_net_amount    NUMERIC(15, 2)  NOT NULL DEFAULT 0,
    total_profit        NUMERIC(15, 2)  NOT NULL DEFAULT 0,
    avg_order_value     NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    -- Metadata
    last_refreshed_at   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(year, month_num, product_key, store_key)
);

COMMENT ON TABLE fact_sales_monthly_agg IS 'Pre-aggregated monthly sales for fast dashboard queries';
