#!/bin/bash
# ============================================================
# DATA WAREHOUSE SETUP SCRIPT
# Usage: bash scripts/setup.sh
# ============================================================

set -e  # Exit on any error

# --- Configuration ---
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-retail_dw}"
DB_USER="${DB_USER:-postgres}"

echo "============================================"
echo "  Retail Sales Data Warehouse - Setup"
echo "============================================"
echo "Host:     $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "User:     $DB_USER"
echo ""

# Create database if not exists
echo "[1/6] Creating database '$DB_NAME'..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 || \
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "CREATE DATABASE $DB_NAME;"
echo "✓ Database ready"

# Run DDL - Dimension Tables
echo "[2/6] Creating dimension tables..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/ddl/01_create_dimensions.sql
echo "✓ Dimensions created"

# Run DDL - Fact Tables
echo "[3/6] Creating fact tables..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/ddl/02_create_fact_tables.sql
echo "✓ Fact tables created"

# Run Indexes
echo "[4/6] Creating indexes..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/indexes/idx_performance.sql
echo "✓ Indexes created"

# Load Sample Data
echo "[5/6] Loading sample dimension data..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/dml/01_load_dimensions.sql
echo "✓ Dimensions populated"

echo "[5b] Loading sample fact data..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/dml/02_load_facts.sql
echo "✓ Facts populated"

# Create Views & Stored Procedures
echo "[6/6] Creating views and stored procedures..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/views/vw_sales_analysis.sql
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/stored_procedures/sp_load_sales.sql
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/etl/etl_pipeline.sql
echo "✓ Views and procedures created"

echo ""
echo "============================================"
echo "  ✅ Setup Complete!"
echo "============================================"
echo ""
echo "Connect with:"
echo "  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"
echo ""
echo "Quick test:"
echo "  SELECT * FROM vw_sales_detail LIMIT 10;"
