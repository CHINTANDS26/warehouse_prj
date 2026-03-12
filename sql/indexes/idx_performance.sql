-- ============================================================
-- DATA WAREHOUSE - PERFORMANCE INDEXES
-- ============================================================

-- FACT_SALES Indexes
CREATE INDEX idx_fact_sales_date_key       ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_customer_key   ON fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product_key    ON fact_sales(product_key);
CREATE INDEX idx_fact_sales_store_key      ON fact_sales(store_key);
CREATE INDEX idx_fact_sales_order_id       ON fact_sales(order_id);
CREATE INDEX idx_fact_sales_channel        ON fact_sales(sale_channel);
CREATE INDEX idx_fact_sales_composite      ON fact_sales(date_key, store_key, product_key);

-- DIM_DATE Indexes
CREATE INDEX idx_dim_date_full_date        ON dim_date(full_date);
CREATE INDEX idx_dim_date_year_month       ON dim_date(year, month_num);
CREATE INDEX idx_dim_date_year             ON dim_date(year);

-- DIM_CUSTOMER Indexes
CREATE INDEX idx_dim_customer_id           ON dim_customer(customer_id);
CREATE INDEX idx_dim_customer_segment      ON dim_customer(segment);
CREATE INDEX idx_dim_customer_city         ON dim_customer(city);

-- DIM_PRODUCT Indexes
CREATE INDEX idx_dim_product_id            ON dim_product(product_id);
CREATE INDEX idx_dim_product_category      ON dim_product(category);
CREATE INDEX idx_dim_product_brand         ON dim_product(brand);

-- DIM_STORE Indexes
CREATE INDEX idx_dim_store_id              ON dim_store(store_id);
CREATE INDEX idx_dim_store_region          ON dim_store(region);
CREATE INDEX idx_dim_store_city            ON dim_store(city);
