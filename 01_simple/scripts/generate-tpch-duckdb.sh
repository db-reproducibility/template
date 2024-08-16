#!/bin/bash


echo -n "* Removing existing tables..."
duckdb data/duckdb.db 2>&1 > /dev/null <<EOF
  DROP TABLE IF EXISTS customer;
  DROP TABLE IF EXISTS lineitem;
  DROP TABLE IF EXISTS nation;
  DROP TABLE IF EXISTS orders;
  DROP TABLE IF EXISTS part;
  DROP TABLE IF EXISTS partsupp;
  DROP TABLE IF EXISTS region;
  DROP TABLE IF EXISTS supplier;
EOF
echo "done"

echo -n "* Generating TPC-H data..."
duckdb data/duckdb.db 2>&1 > /dev/null <<EOF
  LOAD tpch;
  CALL dbgen(sf = 1);
EOF
echo "done"

echo -n "* Exporting TPC-H data to CSV files..."
mkdir -p data/tables
duckdb data/duckdb.db 2>&1 > /dev/null <<EOF
  COPY customer TO "data/tables/customer.csv" (FORMAT CSV);
  COPY lineitem TO "data/tables/lineitem.csv" (FORMAT CSV);
  COPY nation   TO "data/tables/nation.csv"   (FORMAT CSV);
  COPY orders   TO "data/tables/orders.csv"   (FORMAT CSV);
  COPY part     TO "data/tables/part.csv"     (FORMAT CSV);
  COPY partsupp TO "data/tables/partsupp.csv" (FORMAT CSV);
  COPY region   TO "data/tables/region.csv"   (FORMAT CSV);
  COPY supplier TO "data/tables/supplier.csv" (FORMAT CSV);
EOF
echo "done"
