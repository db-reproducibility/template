#!/bin/bash

mkdir -p /project/data/setup

echo -n "* Removing existing tables..."
duckdb /project/data/setup/duckdb.db 2>&1 > /dev/null <<EOF
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
duckdb /project/data/setup/duckdb.db 2>&1 > /dev/null <<EOF
  LOAD tpch;
  CALL dbgen(sf = 1);
EOF
echo "done"

echo -n "* Exporting TPC-H data to CSV files..."
duckdb /project/data/setup/duckdb.db 2>&1 > /dev/null <<EOF
  COPY customer TO "/project/data/setup/customer.csv" (FORMAT CSV);
  COPY lineitem TO "/project/data/setup/lineitem.csv" (FORMAT CSV);
  COPY nation   TO "/project/data/setup/nation.csv"   (FORMAT CSV);
  COPY orders   TO "/project/data/setup/orders.csv"   (FORMAT CSV);
  COPY part     TO "/project/data/setup/part.csv"     (FORMAT CSV);
  COPY partsupp TO "/project/data/setup/partsupp.csv" (FORMAT CSV);
  COPY region   TO "/project/data/setup/region.csv"   (FORMAT CSV);
  COPY supplier TO "/project/data/setup/supplier.csv" (FORMAT CSV);
EOF
echo "done"
