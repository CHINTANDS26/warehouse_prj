-- ============================================================
-- DATA WAREHOUSE - LOAD DIMENSION TABLES (Sample Data)
-- ============================================================

-- ============================================================
-- POPULATE DIM_DATE (2023-01-01 to 2025-12-31)
-- ============================================================
INSERT INTO dim_date (
    date_key, full_date, day_of_week, day_name, day_of_month,
    day_of_year, week_of_year, month_num, month_name, month_abbr,
    quarter, quarter_name, year, is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT                         AS date_key,
    d                                                    AS full_date,
    EXTRACT(DOW FROM d)::SMALLINT + 1                   AS day_of_week,
    TO_CHAR(d, 'Day')                                   AS day_name,
    EXTRACT(DAY FROM d)::SMALLINT                       AS day_of_month,
    EXTRACT(DOY FROM d)::SMALLINT                       AS day_of_year,
    EXTRACT(WEEK FROM d)::SMALLINT                      AS week_of_year,
    EXTRACT(MONTH FROM d)::SMALLINT                     AS month_num,
    TO_CHAR(d, 'Month')                                 AS month_name,
    TO_CHAR(d, 'Mon')                                   AS month_abbr,
    EXTRACT(QUARTER FROM d)::SMALLINT                   AS quarter,
    'Q' || EXTRACT(QUARTER FROM d)::TEXT                AS quarter_name,
    EXTRACT(YEAR FROM d)::SMALLINT                      AS year,
    EXTRACT(DOW FROM d) IN (0, 6)                       AS is_weekend
FROM generate_series('2023-01-01'::DATE, '2025-12-31'::DATE, '1 day') AS d;

-- ============================================================
-- POPULATE DIM_CUSTOMER (20 Sample Customers)
-- ============================================================
INSERT INTO dim_customer (
    customer_id, first_name, last_name, email, phone, gender,
    date_of_birth, age_group, city, state, country, postal_code,
    segment, loyalty_points, registration_date
) VALUES
('CUST001', 'Aarav',     'Sharma',     'aarav.sharma@email.com',     '9876543210', 'M', '1990-03-15', '26-35', 'Mumbai',    'Maharashtra', 'India', '400001', 'Gold',     1250, '2021-06-01'),
('CUST002', 'Priya',     'Verma',      'priya.verma@email.com',      '9876543211', 'F', '1985-07-22', '36-45', 'Delhi',     'Delhi',       'India', '110001', 'Platinum', 4800, '2020-01-15'),
('CUST003', 'Rohan',     'Mehta',      'rohan.mehta@email.com',      '9876543212', 'M', '1995-11-10', '18-25', 'Bangalore', 'Karnataka',   'India', '560001', 'Silver',    620, '2022-03-20'),
('CUST004', 'Sneha',     'Patel',      'sneha.patel@email.com',      '9876543213', 'F', '1992-01-30', '26-35', 'Ahmedabad', 'Gujarat',     'India', '380001', 'Gold',     2100, '2021-09-05'),
('CUST005', 'Vikram',    'Singh',      'vikram.singh@email.com',     '9876543214', 'M', '1988-05-18', '36-45', 'Chennai',   'Tamil Nadu',  'India', '600001', 'Bronze',    180, '2023-01-10'),
('CUST006', 'Ananya',    'Krishnan',   'ananya.k@email.com',         '9876543215', 'F', '1997-09-25', '18-25', 'Hyderabad', 'Telangana',   'India', '500001', 'Silver',    750, '2022-07-14'),
('CUST007', 'Arjun',     'Nair',       'arjun.nair@email.com',       '9876543216', 'M', '1983-12-08', '36-45', 'Pune',      'Maharashtra', 'India', '411001', 'Platinum', 5200, '2019-11-22'),
('CUST008', 'Kavitha',   'Reddy',      'kavitha.reddy@email.com',    '9876543217', 'F', '1991-04-17', '26-35', 'Kolkata',   'West Bengal', 'India', '700001', 'Gold',     1800, '2021-02-28'),
('CUST009', 'Rahul',     'Gupta',      'rahul.gupta@email.com',      '9876543218', 'M', '1994-08-03', '26-35', 'Jaipur',    'Rajasthan',   'India', '302001', 'Silver',    430, '2022-05-16'),
('CUST010', 'Meera',     'Iyer',       'meera.iyer@email.com',       '9876543219', 'F', '1987-02-14', '36-45', 'Bangalore', 'Karnataka',   'India', '560002', 'Gold',     2950, '2020-08-07'),
('CUST011', 'Suresh',    'Kumar',      'suresh.kumar@email.com',     '9876543220', 'M', '1980-06-28', '46-55', 'Mumbai',    'Maharashtra', 'India', '400002', 'Bronze',    90,  '2023-04-03'),
('CUST012', 'Divya',     'Pillai',     'divya.pillai@email.com',     '9876543221', 'F', '1996-10-11', '18-25', 'Chennai',   'Tamil Nadu',  'India', '600002', 'Silver',    510, '2022-09-19'),
('CUST013', 'Aditya',    'Joshi',      'aditya.joshi@email.com',     '9876543222', 'M', '1993-03-22', '26-35', 'Delhi',     'Delhi',       'India', '110002', 'Gold',     1650, '2021-12-30'),
('CUST014', 'Pooja',     'Bhatia',     'pooja.bhatia@email.com',     '9876543223', 'F', '1989-07-05', '36-45', 'Ahmedabad', 'Gujarat',     'India', '380002', 'Platinum', 6100, '2018-06-12'),
('CUST015', 'Nikhil',    'Desai',      'nikhil.desai@email.com',     '9876543224', 'M', '1998-01-19', '18-25', 'Hyderabad', 'Telangana',   'India', '500002', 'Bronze',   220,  '2023-06-08'),
('CUST016', 'Lakshmi',   'Venkat',     'lakshmi.v@email.com',        '9876543225', 'F', '1986-11-30', '36-45', 'Pune',      'Maharashtra', 'India', '411002', 'Silver',   880,  '2022-01-25'),
('CUST017', 'Karan',     'Malhotra',   'karan.malhotra@email.com',   '9876543226', 'M', '1992-04-09', '26-35', 'Kolkata',   'West Bengal', 'India', '700002', 'Gold',     2300, '2021-05-17'),
('CUST018', 'Nisha',     'Agarwal',    'nisha.agarwal@email.com',    '9876543227', 'F', '1995-08-14', '26-35', 'Jaipur',    'Rajasthan',   'India', '302002', 'Silver',   670,  '2022-10-04'),
('CUST019', 'Sanjay',    'Tiwari',     'sanjay.tiwari@email.com',    '9876543228', 'M', '1984-12-26', '36-45', 'Mumbai',    'Maharashtra', 'India', '400003', 'Bronze',   150,  '2023-02-14'),
('CUST020', 'Rekha',     'Naidu',      'rekha.naidu@email.com',      '9876543229', 'F', '1990-05-07', '26-35', 'Bangalore', 'Karnataka',   'India', '560003', 'Platinum', 4400, '2020-04-21');

-- ============================================================
-- POPULATE DIM_PRODUCT (30 Sample Products)
-- ============================================================
INSERT INTO dim_product (
    product_id, product_name, product_code, sku, category,
    sub_category, brand, supplier, unit_cost, unit_price, launch_date
) VALUES
('PROD001', 'Laptop Pro 15"',              'LPRO15',  'LP-001', 'Electronics',  'Laptops',       'TechBrand',   'TechSupply Co',      45000, 65000, '2022-01-01'),
('PROD002', 'Wireless Headphones',         'WH200',   'WH-002', 'Electronics',  'Audio',         'SoundMax',    'Audio World',         2500,  4500,  '2022-03-15'),
('PROD003', 'Smartphone X12',              'SPX12',   'SP-003', 'Electronics',  'Smartphones',   'MobileTech',  'Mobile Dist',        18000, 28000, '2022-06-01'),
('PROD004', 'USB-C Hub 7-in-1',            'USBHUB7', 'UH-004', 'Electronics',  'Accessories',   'ConnectPro',  'Tech Parts Ltd',       800,  1800,  '2022-01-20'),
('PROD005', 'Mechanical Keyboard',         'MECHKB',  'KB-005', 'Electronics',  'Peripherals',   'TypeFast',    'Input Devices Co',    3200,  5500,  '2022-02-10'),
('PROD006', 'Men Formal Shirt (L)',        'MFSL',    'MS-006', 'Apparel',      'Men Top Wear',  'StyleUp',     'Fashion Hub',          450,  1200,  '2022-07-01'),
('PROD007', 'Women Kurti Cotton',          'WKRTC',   'WK-007', 'Apparel',      'Women Ethnic',  'EthnicWear',  'Textile Co',           350,   950,  '2022-07-05'),
('PROD008', 'Running Shoes Nike Air',      'NSAIR',   'RS-008', 'Footwear',     'Sports Shoes',  'Nike',        'Sports Dist',         2800,  5500,  '2022-04-20'),
('PROD009', 'Denim Jeans Slim Fit',        'DJSF',    'DJ-009', 'Apparel',      'Men Bottom',    'DenimCo',     'Fashion Hub',          600,  1800,  '2022-08-01'),
('PROD010', 'Yoga Mat 6mm',                'YMAT6',   'YM-010', 'Sports',       'Yoga',          'FitLife',     'Sports World',         350,   750,  '2022-05-15'),
('PROD011', 'Protein Powder Whey 1kg',     'PPWH1K',  'PP-011', 'Health',       'Supplements',   'NutriMax',    'Health Dist',         1200,  2200,  '2022-03-01'),
('PROD012', 'Face Moisturizer SPF30',      'FMSPF30', 'FM-012', 'Beauty',       'Skin Care',     'GlowUp',      'Beauty Supply',         280,   650,  '2022-09-10'),
('PROD013', 'Rice Basmati 5kg',            'RBAS5K',  'RB-013', 'Grocery',      'Grains',        'Freshfields', 'Agro Traders',         350,   520,  '2021-01-01'),
('PROD014', 'Olive Oil Extra Virgin 1L',   'OOEV1L',  'OO-014', 'Grocery',      'Oils',          'HealthyChoice','Food Dist',           420,   650,  '2021-06-01'),
('PROD015', 'Coffee Beans Premium 500g',   'CBP500',  'CB-015', 'Grocery',      'Beverages',     'BeanMaster',  'Coffee Traders',        550,   950,  '2022-01-15'),
('PROD016', 'Air Fryer 4L Digital',        'AFD4L',   'AF-016', 'Home',         'Kitchen Appl',  'CookSmart',   'Home Appliances',      3500,  6500,  '2022-10-01'),
('PROD017', 'Bed Sheet Set King',          'BSSK',    'BS-017', 'Home',         'Bedding',       'ComfortHome', 'Textile Mill',          800,  2200,  '2022-07-15'),
('PROD018', 'Pressure Cooker 5L',          'PC5L',    'PC-018', 'Home',         'Cookware',      'CookPro',     'Cookware Dist',        1200,  2500,  '2022-05-01'),
('PROD019', 'Stainless Steel Water Bottle','SSWB',    'WB-019', 'Sports',       'Hydration',     'HydroFlask',  'Sports World',          400,   850,  '2022-04-01'),
('PROD020', 'Notebook A4 200 Pages',       'NBA4200', 'NB-020', 'Stationery',   'Notebooks',     'WriteWell',   'Stationery Hub',         60,   150,  '2021-01-01'),
('PROD021', 'Wireless Mouse Ergonomic',    'WMERG',   'WM-021', 'Electronics',  'Peripherals',   'ClickPro',    'Input Devices Co',      600,  1400,  '2022-03-20'),
('PROD022', 'Sunscreen SPF50 100ml',       'SSP50',   'SS-022', 'Beauty',       'Sun Care',      'SunShield',   'Beauty Supply',         180,   450,  '2022-04-15'),
('PROD023', 'Wooden Dining Table 6-seater','WDTS',    'DT-023', 'Furniture',    'Dining',        'WoodCraft',   'Furniture House',      12000, 22000, '2022-02-01'),
('PROD024', 'Office Chair Ergonomic',      'OCERG',   'OC-024', 'Furniture',    'Seating',       'ErgoSit',     'Office Furniture',      5500, 11000, '2022-01-15'),
('PROD025', 'Bluetooth Speaker 20W',       'BTS20W',  'BS-025', 'Electronics',  'Audio',         'SoundMax',    'Audio World',           1200,  2800,  '2022-06-10'),
('PROD026', 'LED Desk Lamp USB',           'LEDDU',   'LD-026', 'Electronics',  'Lighting',      'BrightLight', 'Lighting Co',            350,   800,  '2022-05-20'),
('PROD027', 'Dumbbells Set 10kg Pair',     'DS10P',   'DS-027', 'Sports',       'Gym Equipment', 'IronFit',     'Sports World',          1800,  3500,  '2022-03-10'),
('PROD028', 'Multivitamin Tablets 60ct',   'MVTB60',  'MV-028', 'Health',       'Vitamins',      'HealthPlus',  'Pharma Dist',            280,   650,  '2022-02-28'),
('PROD029', 'Canvas Backpack 30L',         'CBP30L',  'BP-029', 'Bags',         'Backpacks',     'TravelPro',   'Bag Traders',            900,  2200,  '2022-07-01'),
('PROD030', 'Smart Watch Fitness',         'SWFIT',   'SW-030', 'Electronics',  'Wearables',     'FitTech',     'Tech Dist',             4500,  8500,  '2022-08-15');

-- ============================================================
-- POPULATE DIM_STORE (10 Stores)
-- ============================================================
INSERT INTO dim_store (
    store_id, store_name, store_type, address_line1, city, state,
    country, postal_code, region, zone, manager_name, open_date, floor_area_sqft
) VALUES
('STR001', 'Mumbai Flagship',      'Flagship', 'High Street, Bandra',     'Mumbai',    'Maharashtra', 'India', '400050', 'West',  'Zone-W1', 'Rajesh Kumar',    '2018-01-15', 8500),
('STR002', 'Delhi Central',        'Flagship', 'Connaught Place',         'Delhi',     'Delhi',       'India', '110001', 'North', 'Zone-N1', 'Priya Sharma',    '2018-06-20', 9200),
('STR003', 'Bangalore Tech Park',  'Express',  'Koramangala 5th Block',   'Bangalore', 'Karnataka',   'India', '560034', 'South', 'Zone-S1', 'Arjun Nair',      '2019-03-10', 4500),
('STR004', 'Chennai Express',      'Express',  'Anna Nagar West',         'Chennai',   'Tamil Nadu',  'India', '600040', 'South', 'Zone-S2', 'Kavitha Reddy',   '2019-09-05', 4200),
('STR005', 'Hyderabad Hub',        'Flagship', 'Jubilee Hills',           'Hyderabad', 'Telangana',   'India', '500033', 'South', 'Zone-S3', 'Vikram Singh',    '2020-01-22', 7800),
('STR006', 'Pune City Center',     'Express',  'FC Road, Deccan',         'Pune',      'Maharashtra', 'India', '411004', 'West',  'Zone-W2', 'Sneha Patel',     '2020-07-14', 4800),
('STR007', 'Kolkata Park Street',  'Flagship', 'Park Street',             'Kolkata',   'West Bengal', 'India', '700016', 'East',  'Zone-E1', 'Aditya Joshi',    '2019-11-01', 6900),
('STR008', 'Ahmedabad Galleria',   'Express',  'SG Highway',              'Ahmedabad', 'Gujarat',     'India', '380054', 'West',  'Zone-W3', 'Ananya Krishnan', '2021-02-28', 5100),
('STR009', 'Jaipur Pink City',     'Express',  'MI Road',                 'Jaipur',    'Rajasthan',   'India', '302001', 'North', 'Zone-N2', 'Meera Iyer',      '2021-08-15', 3900),
('STR010', 'Online Store',         'Online',   'Virtual',                 'Mumbai',    'Maharashtra', 'India', '400001', 'Pan-India', 'All', 'Karan Malhotra',  '2020-04-01', 0);
