-- ============================================================
-- DATA WAREHOUSE - ETL PIPELINE
-- Incremental Load Strategy
-- ============================================================

-- ============================================================
-- STEP 1: Create Staging Table (temporary landing zone)
-- ============================================================
CREATE TABLE IF NOT EXISTS stg_sales_raw (
    stg_id          BIGSERIAL       PRIMARY KEY,
    raw_order_id    VARCHAR(30),
    raw_order_line  SMALLINT,
    order_date      DATE,
    customer_id     VARCHAR(20),
    product_id      VARCHAR(20),
    store_id        VARCHAR(20),
    quantity        INT,
    unit_price      NUMERIC(12,2),
    discount_pct    NUMERIC(5,2)    DEFAULT 0,
    sale_channel    VARCHAR(20),
    payment_method  VARCHAR(30),
    -- ETL control columns
    load_date       DATE            DEFAULT CURRENT_DATE,
    is_processed    BOOLEAN         DEFAULT FALSE,
    error_message   TEXT,
    processed_at    TIMESTAMP
);

-- ============================================================
-- STEP 2: ETL Function - Process Staging to Warehouse
-- ============================================================
CREATE OR REPLACE FUNCTION fn_etl_process_staging()
RETURNS TABLE(
    processed_count INT,
    error_count     INT,
    run_timestamp   TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_processed     INT := 0;
    v_errors        INT := 0;
    r               RECORD;
BEGIN
    FOR r IN
        SELECT * FROM stg_sales_raw
        WHERE is_processed = FALSE
        ORDER BY stg_id
    LOOP
        BEGIN
            CALL sp_load_sales(
                TO_CHAR(r.order_date, 'YYYYMMDD')::INT,
                r.customer_id,
                r.product_id,
                r.store_id,
                r.raw_order_id,
                r.raw_order_line,
                r.quantity,
                r.unit_price,
                r.discount_pct,
                r.sale_channel,
                r.payment_method
            );

            UPDATE stg_sales_raw
            SET is_processed = TRUE, processed_at = CURRENT_TIMESTAMP
            WHERE stg_id = r.stg_id;

            v_processed := v_processed + 1;

        EXCEPTION WHEN OTHERS THEN
            UPDATE stg_sales_raw
            SET error_message = SQLERRM, processed_at = CURRENT_TIMESTAMP
            WHERE stg_id = r.stg_id;
            v_errors := v_errors + 1;
        END;
    END LOOP;

    RETURN QUERY SELECT v_processed, v_errors, CURRENT_TIMESTAMP;
END;
$$;

-- ============================================================
-- STEP 3: Run ETL (call this to process all pending rows)
-- ============================================================
-- SELECT * FROM fn_etl_process_staging();

-- ============================================================
-- STEP 4: Refresh Monthly Aggregates After ETL
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_refresh_monthly_agg(
    p_year  SMALLINT DEFAULT NULL,
    p_month SMALLINT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO fact_sales_monthly_agg (
        year, month_num, product_key, store_key,
        total_orders, total_quantity, total_gross_amount,
        total_discount, total_tax, total_net_amount, total_profit, avg_order_value
    )
    SELECT
        d.year, d.month_num, f.product_key, f.store_key,
        COUNT(DISTINCT f.order_id),
        SUM(f.quantity_sold),
        SUM(f.gross_amount),
        SUM(f.discount_amount),
        SUM(f.tax_amount),
        SUM(f.net_amount),
        SUM(f.profit_amount),
        AVG(f.total_amount)
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    WHERE (p_year IS NULL OR d.year = p_year)
      AND (p_month IS NULL OR d.month_num = p_month)
    GROUP BY d.year, d.month_num, f.product_key, f.store_key
    ON CONFLICT (year, month_num, product_key, store_key)
    DO UPDATE SET
        total_orders        = EXCLUDED.total_orders,
        total_quantity      = EXCLUDED.total_quantity,
        total_gross_amount  = EXCLUDED.total_gross_amount,
        total_discount      = EXCLUDED.total_discount,
        total_tax           = EXCLUDED.total_tax,
        total_net_amount    = EXCLUDED.total_net_amount,
        total_profit        = EXCLUDED.total_profit,
        avg_order_value     = EXCLUDED.avg_order_value,
        last_refreshed_at   = CURRENT_TIMESTAMP;

    RAISE NOTICE 'Monthly aggregates refreshed for year=%, month=%', p_year, p_month;
END;
$$;
