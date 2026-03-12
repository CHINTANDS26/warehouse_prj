-- ============================================================
-- DATA WAREHOUSE - LOAD FACT_SALES (Sample Transactions)
-- ============================================================

INSERT INTO fact_sales (
    date_key, customer_key, product_key, store_key,
    order_id, order_line_num, invoice_number,
    quantity_sold, unit_price, unit_cost,
    discount_pct, discount_amount, tax_amount,
    gross_amount, net_amount, total_amount, profit_amount,
    sale_channel, payment_method
) VALUES
-- Jan 2024 Sales
(20240105, 2,  1, 1, 'ORD-2024-0001', 1, 'INV-2024-0001', 1,  65000, 45000, 5.0,  3250,  11115, 65000, 61750, 72865, 16750, 'In-Store', 'Card'),
(20240105, 2,  2, 1, 'ORD-2024-0001', 2, 'INV-2024-0001', 1,   4500,  2500, 5.0,   225,    762,  4500,  4275,  5037,  1775, 'In-Store', 'Card'),
(20240108, 7,  3, 2, 'ORD-2024-0002', 1, 'INV-2024-0002', 1,  28000, 18000, 0.0,     0,   5040, 28000, 28000, 33040, 10000, 'In-Store', 'UPI'),
(20240112, 4,  6, 8, 'ORD-2024-0003', 1, 'INV-2024-0003', 3,   1200,   450, 10.0,  360,    583,  3600,  3240,  3823,  2250, 'In-Store', 'Cash'),
(20240115, 14, 24, 2, 'ORD-2024-0004', 1, 'INV-2024-0004', 1, 11000,  5500, 8.0,   880,   1825, 11000, 10120, 11945,  4620, 'In-Store', 'Card'),
(20240118, 10, 12, 3, 'ORD-2024-0005', 1, 'INV-2024-0005', 2,    650,   280, 0.0,     0,    234,  1300,  1300,  1534,   740, 'Online',   'UPI'),
(20240120, 1,  15, 10, 'ORD-2024-0006', 1, 'INV-2024-0006', 2,   950,   550, 5.0,    95,    324,  1900,  1805,  2129,   710, 'Online',   'Card'),
(20240122, 3,  10, 3, 'ORD-2024-0007', 1, 'INV-2024-0007', 1,    750,   350, 0.0,     0,    135,   750,   750,   885,   400, 'In-Store', 'Cash'),
(20240125, 6,  11, 5, 'ORD-2024-0008', 1, 'INV-2024-0008', 1,   2200,  1200, 0.0,    0,    396,  2200,  2200,  2596,  1000, 'In-Store', 'Card'),
(20240128, 9,  20, 9, 'ORD-2024-0009', 1, 'INV-2024-0009', 5,    150,    60, 0.0,    0,    135,   750,   750,   885,   450, 'In-Store', 'Cash'),
-- Feb 2024 Sales
(20240202, 14,  1, 2, 'ORD-2024-0010', 1, 'INV-2024-0010', 1,  65000, 45000, 12.0, 7800, 10296, 65000, 57200, 67496, 12200, 'In-Store', 'EMI'),
(20240205, 5,  8, 4, 'ORD-2024-0011', 1, 'INV-2024-0011', 1,   5500,  2800, 5.0,   275,    944,  5500,  5225,  6169,  2425, 'In-Store', 'Card'),
(20240208, 17, 25, 7, 'ORD-2024-0012', 1, 'INV-2024-0012', 1,   2800,  1200, 0.0,    0,    504,  2800,  2800,  3304,  1600, 'In-Store', 'UPI'),
(20240210, 8,  17, 7, 'ORD-2024-0013', 1, 'INV-2024-0013', 1,   2200,   800, 5.0,   110,    375,  2200,  2090,  2465,  1290, 'In-Store', 'Card'),
(20240212, 20, 30, 10, 'ORD-2024-0014', 1, 'INV-2024-0014', 1,  8500,  4500, 10.0,  850,   1377, 8500,  7650,  9027,  3150, 'Online',   'Card'),
(20240215, 13,  5, 2, 'ORD-2024-0015', 1, 'INV-2024-0015', 1,   5500,  3200, 5.0,   275,    944,  5500,  5225,  6169,  2025, 'In-Store', 'Card'),
(20240218, 11, 13, 1, 'ORD-2024-0016', 1, 'INV-2024-0016', 2,    520,   350, 0.0,    0,    187,  1040,  1040,  1227,   340, 'In-Store', 'Cash'),
(20240220, 16, 22, 6, 'ORD-2024-0017', 1, 'INV-2024-0017', 3,    450,   180, 0.0,    0,    243,  1350,  1350,  1593,   810, 'In-Store', 'UPI'),
(20240225, 2,  23, 1, 'ORD-2024-0018', 1, 'INV-2024-0018', 1,  22000, 12000, 5.0, 1100,   3762, 22000, 20900, 24662,  8900, 'In-Store', 'EMI'),
(20240228, 7,  27, 5, 'ORD-2024-0019', 1, 'INV-2024-0019', 1,   3500,  1800, 0.0,    0,    630,  3500,  3500,  4130,  1700, 'In-Store', 'Card'),
-- Mar 2024 Sales
(20240305, 4,  16, 8, 'ORD-2024-0020', 1, 'INV-2024-0020', 1,   6500,  3500, 8.0,   520,   1076, 6500,  5980,  7056,  2480, 'In-Store', 'EMI'),
(20240308, 12, 30, 10, 'ORD-2024-0021', 1, 'INV-2024-0021', 1,  8500,  4500, 5.0,   425,   1454, 8500,  8075,  9529,  3575, 'Online',   'Card'),
(20240312, 18,  7, 9, 'ORD-2024-0022', 1, 'INV-2024-0022', 2,    950,   350, 0.0,    0,    342,  1900,  1900,  2242,  1200, 'In-Store', 'Cash'),
(20240315, 1,  21, 10, 'ORD-2024-0023', 1, 'INV-2024-0023', 1,  1400,   600, 5.0,    70,    239,  1400,  1330,  1569,   730, 'Online',   'UPI'),
(20240318, 9,  28, 9, 'ORD-2024-0024', 1, 'INV-2024-0024', 2,    650,   280, 0.0,    0,    234,  1300,  1300,  1534,   740, 'In-Store', 'Cash'),
(20240320, 3,   4, 3, 'ORD-2024-0025', 1, 'INV-2024-0025', 1,   1800,   800, 10.0,  180,    290,  1800,  1620,  1910,   820, 'In-Store', 'UPI'),
(20240325, 14,  9, 2, 'ORD-2024-0026', 1, 'INV-2024-0026', 1,   1800,   600, 5.0,    90,    308,  1800,  1710,  2018,  1110, 'In-Store', 'Card'),
(20240328, 6,  14, 5, 'ORD-2024-0027', 1, 'INV-2024-0027', 2,    650,   420, 0.0,    0,    234,  1300,  1300,  1534,   460, 'In-Store', 'UPI'),
(20240330, 20, 29, 10, 'ORD-2024-0028', 1, 'INV-2024-0028', 1,  2200,   900, 8.0,   176,    362,  2200,  2024,  2386,  1124, 'Online',   'Card'),
(20240331, 8,  19, 7, 'ORD-2024-0029', 1, 'INV-2024-0029', 2,    850,   400, 0.0,    0,    306,  1700,  1700,  2006,   900, 'In-Store', 'Cash');

-- ============================================================
-- REFRESH MONTHLY AGGREGATE TABLE
-- ============================================================
INSERT INTO fact_sales_monthly_agg (
    year, month_num, product_key, store_key,
    total_orders, total_quantity, total_gross_amount,
    total_discount, total_tax, total_net_amount, total_profit, avg_order_value
)
SELECT
    d.year,
    d.month_num,
    f.product_key,
    f.store_key,
    COUNT(DISTINCT f.order_id)              AS total_orders,
    SUM(f.quantity_sold)                    AS total_quantity,
    SUM(f.gross_amount)                     AS total_gross_amount,
    SUM(f.discount_amount)                  AS total_discount,
    SUM(f.tax_amount)                       AS total_tax,
    SUM(f.net_amount)                       AS total_net_amount,
    SUM(f.profit_amount)                    AS total_profit,
    AVG(f.total_amount)                     AS avg_order_value
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
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
