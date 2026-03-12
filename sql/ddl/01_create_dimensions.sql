-- ============================================================
-- DATA WAREHOUSE - DIMENSION TABLES
-- Schema: Star Schema for Retail Sales Analytics
-- ============================================================

-- Drop tables if they exist (in dependency order)
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_store CASCADE;

-- ============================================================
-- DIM_DATE - Date Dimension
-- ============================================================
CREATE TABLE dim_date (
    date_key        INT             PRIMARY KEY,  -- YYYYMMDD format
    full_date       DATE            NOT NULL UNIQUE,
    day_of_week     SMALLINT        NOT NULL,     -- 1=Sunday ... 7=Saturday
    day_name        VARCHAR(10)     NOT NULL,
    day_of_month    SMALLINT        NOT NULL,
    day_of_year     SMALLINT        NOT NULL,
    week_of_year    SMALLINT        NOT NULL,
    month_num       SMALLINT        NOT NULL,
    month_name      VARCHAR(10)     NOT NULL,
    month_abbr      CHAR(3)         NOT NULL,
    quarter         SMALLINT        NOT NULL,     -- 1-4
    quarter_name    CHAR(2)         NOT NULL,     -- Q1-Q4
    year            SMALLINT        NOT NULL,
    is_weekend      BOOLEAN         NOT NULL DEFAULT FALSE,
    is_holiday      BOOLEAN         NOT NULL DEFAULT FALSE,
    fiscal_year     SMALLINT,
    fiscal_quarter  SMALLINT,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE dim_date IS 'Date dimension table with full calendar hierarchy';

-- ============================================================
-- DIM_CUSTOMER - Customer Dimension
-- ============================================================
CREATE TABLE dim_customer (
    customer_key        SERIAL          PRIMARY KEY,
    customer_id         VARCHAR(20)     NOT NULL UNIQUE,  -- Natural/Business key
    first_name          VARCHAR(50)     NOT NULL,
    last_name           VARCHAR(50)     NOT NULL,
    full_name           VARCHAR(100)    GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    email               VARCHAR(100),
    phone               VARCHAR(20),
    gender              CHAR(1),                          -- M / F / O
    date_of_birth       DATE,
    age_group           VARCHAR(20),                      -- 18-25, 26-35, etc.
    address_line1       VARCHAR(100),
    address_line2       VARCHAR(100),
    city                VARCHAR(50),
    state               VARCHAR(50),
    country             VARCHAR(50)     NOT NULL DEFAULT 'India',
    postal_code         VARCHAR(20),
    segment             VARCHAR(30),                      -- Bronze, Silver, Gold, Platinum
    loyalty_points      INT             NOT NULL DEFAULT 0,
    registration_date   DATE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    -- SCD Type 2 fields
    effective_date      DATE            NOT NULL DEFAULT CURRENT_DATE,
    expiry_date         DATE            NOT NULL DEFAULT '9999-12-31',
    is_current          BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE dim_customer IS 'Customer dimension with SCD Type 2 for tracking history';

-- ============================================================
-- DIM_PRODUCT - Product Dimension
-- ============================================================
CREATE TABLE dim_product (
    product_key         SERIAL          PRIMARY KEY,
    product_id          VARCHAR(20)     NOT NULL UNIQUE,  -- Natural/Business key
    product_name        VARCHAR(150)    NOT NULL,
    product_code        VARCHAR(30),
    sku                 VARCHAR(50),
    category            VARCHAR(50)     NOT NULL,
    sub_category        VARCHAR(50),
    brand               VARCHAR(50),
    supplier            VARCHAR(100),
    unit_cost           NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    unit_price          NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    profit_margin_pct   NUMERIC(5, 2)   GENERATED ALWAYS AS (
                            CASE WHEN unit_price > 0
                                THEN ROUND(((unit_price - unit_cost) / unit_price) * 100, 2)
                            ELSE 0 END
                        ) STORED,
    weight_kg           NUMERIC(8, 3),
    is_taxable          BOOLEAN         NOT NULL DEFAULT TRUE,
    tax_rate_pct        NUMERIC(5, 2)   NOT NULL DEFAULT 18.00,  -- GST default
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    launch_date         DATE,
    discontinue_date    DATE,
    -- SCD Type 2 fields
    effective_date      DATE            NOT NULL DEFAULT CURRENT_DATE,
    expiry_date         DATE            NOT NULL DEFAULT '9999-12-31',
    is_current          BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE dim_product IS 'Product dimension with category hierarchy and SCD Type 2';

-- ============================================================
-- DIM_STORE - Store Dimension
-- ============================================================
CREATE TABLE dim_store (
    store_key           SERIAL          PRIMARY KEY,
    store_id            VARCHAR(20)     NOT NULL UNIQUE,  -- Natural/Business key
    store_name          VARCHAR(100)    NOT NULL,
    store_type          VARCHAR(30),                      -- Flagship, Express, Online
    address_line1       VARCHAR(100),
    city                VARCHAR(50)     NOT NULL,
    state               VARCHAR(50)     NOT NULL,
    country             VARCHAR(50)     NOT NULL DEFAULT 'India',
    postal_code         VARCHAR(20),
    region              VARCHAR(30),                      -- North, South, East, West
    zone                VARCHAR(30),
    manager_name        VARCHAR(100),
    phone               VARCHAR(20),
    email               VARCHAR(100),
    open_date           DATE,
    close_date          DATE,
    floor_area_sqft     INT,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE dim_store IS 'Store dimension with geographic hierarchy';
