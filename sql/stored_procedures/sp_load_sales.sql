-- ============================================================
-- DATA WAREHOUSE - STORED PROCEDURE: Load Sales
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_load_sales(
    p_date_key          INT,
    p_customer_id       VARCHAR(20),
    p_product_id        VARCHAR(20),
    p_store_id          VARCHAR(20),
    p_order_id          VARCHAR(30),
    p_order_line_num    SMALLINT,
    p_quantity          INT,
    p_unit_price        NUMERIC(12,2),
    p_discount_pct      NUMERIC(5,2) DEFAULT 0,
    p_sale_channel      VARCHAR(20)  DEFAULT 'In-Store',
    p_payment_method    VARCHAR(30)  DEFAULT 'Cash'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_key  INT;
    v_product_key   INT;
    v_store_key     INT;
    v_unit_cost     NUMERIC(12,2);
    v_tax_rate      NUMERIC(5,2);
    v_discount_amt  NUMERIC(12,2);
    v_gross_amt     NUMERIC(12,2);
    v_net_amt       NUMERIC(12,2);
    v_tax_amt       NUMERIC(12,2);
    v_total_amt     NUMERIC(12,2);
    v_profit_amt    NUMERIC(12,2);
BEGIN
    -- Resolve surrogate keys
    SELECT customer_key INTO v_customer_key
    FROM dim_customer WHERE customer_id = p_customer_id AND is_current = TRUE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Customer not found: %', p_customer_id; END IF;

    SELECT product_key, unit_cost, tax_rate_pct INTO v_product_key, v_unit_cost, v_tax_rate
    FROM dim_product WHERE product_id = p_product_id AND is_current = TRUE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Product not found: %', p_product_id; END IF;

    SELECT store_key INTO v_store_key
    FROM dim_store WHERE store_id = p_store_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'Store not found: %', p_store_id; END IF;

    -- Calculate financials
    v_gross_amt    := p_quantity * p_unit_price;
    v_discount_amt := ROUND(v_gross_amt * (p_discount_pct / 100), 2);
    v_net_amt      := v_gross_amt - v_discount_amt;
    v_tax_amt      := ROUND(v_net_amt * (v_tax_rate / 100), 2);
    v_total_amt    := v_net_amt + v_tax_amt;
    v_profit_amt   := v_net_amt - (p_quantity * v_unit_cost);

    -- Insert fact record
    INSERT INTO fact_sales (
        date_key, customer_key, product_key, store_key,
        order_id, order_line_num,
        quantity_sold, unit_price, unit_cost,
        discount_pct, discount_amount, tax_amount,
        gross_amount, net_amount, total_amount, profit_amount,
        sale_channel, payment_method
    ) VALUES (
        p_date_key, v_customer_key, v_product_key, v_store_key,
        p_order_id, p_order_line_num,
        p_quantity, p_unit_price, v_unit_cost,
        p_discount_pct, v_discount_amt, v_tax_amt,
        v_gross_amt, v_net_amt, v_total_amt, v_profit_amt,
        p_sale_channel, p_payment_method
    );

    RAISE NOTICE 'Sale loaded: Order %, Line %, Total: %', p_order_id, p_order_line_num, v_total_amt;
END;
$$;

COMMENT ON PROCEDURE sp_load_sales IS 'Resolves dimension keys, calculates financials, and inserts into fact_sales';
