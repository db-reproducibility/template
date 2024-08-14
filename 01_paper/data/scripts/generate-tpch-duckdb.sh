#!/bin/bash

mkdir -p tables queries

echo -n "* Removing existing tables..."
duckdb duckdb.db 2>&1 > /dev/null <<EOF
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
duckdb duckdb.db 2>&1 > /dev/null <<EOF
  LOAD tpch;
  CALL dbgen(sf = 1);
EOF
echo "done"

echo -n "* Exporting TPC-H data to CSV files..."
duckdb duckdb.db 2>&1 > /dev/null <<EOF
  COPY customer TO "tables/customer.csv" (FORMAT CSV);
  COPY lineitem TO "tables/lineitem.csv" (FORMAT CSV);
  COPY nation   TO "tables/nation.csv"   (FORMAT CSV);
  COPY orders   TO "tables/orders.csv"   (FORMAT CSV);
  COPY part     TO "tables/part.csv"     (FORMAT CSV);
  COPY partsupp TO "tables/partsupp.csv" (FORMAT CSV);
  COPY region   TO "tables/region.csv"   (FORMAT CSV);
  COPY supplier TO "tables/supplier.csv" (FORMAT CSV);
EOF
echo "done"
