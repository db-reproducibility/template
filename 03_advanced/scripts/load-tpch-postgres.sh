#!/bin/bash

echo -n "* Removing existing tables..."
psql -q -E -U postgres 2>&1 > /dev/null <<EOF
  DROP TABLE IF EXISTS NATION CASCADE;
  DROP TABLE IF EXISTS REGION CASCADE;
  DROP TABLE IF EXISTS PART CASCADE;
  DROP TABLE IF EXISTS SUPPLIER CASCADE;
  DROP TABLE IF EXISTS PARTSUPP CASCADE;
  DROP TABLE IF EXISTS CUSTOMER CASCADE;
  DROP TABLE IF EXISTS ORDERS CASCADE;
  DROP TABLE IF EXISTS LINEITEM CASCADE;
  VACUUM FULL;
EOF
echo "done"

echo -n "* Creating tables..."
psql -q -U postgres 2>&1 > /dev/null <<EOF
  CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL,
                              N_NAME       CHAR(25) NOT NULL,
                              N_REGIONKEY  INTEGER NOT NULL,
                              N_COMMENT    VARCHAR(152));

  CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL,
                              R_NAME       CHAR(25) NOT NULL,
                              R_COMMENT    VARCHAR(152));

  CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL,
                            P_NAME        VARCHAR(55) NOT NULL,
                            P_MFGR        CHAR(25) NOT NULL,
                            P_BRAND       CHAR(10) NOT NULL,
                            P_TYPE        VARCHAR(25) NOT NULL,
                            P_SIZE        INTEGER NOT NULL,
                            P_CONTAINER   CHAR(10) NOT NULL,
                            P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                            P_COMMENT     VARCHAR(23) NOT NULL );

  CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL,
                              S_NAME        CHAR(25) NOT NULL,
                              S_ADDRESS     VARCHAR(40) NOT NULL,
                              S_NATIONKEY   INTEGER NOT NULL,
                              S_PHONE       CHAR(15) NOT NULL,
                              S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                              S_COMMENT     VARCHAR(101) NOT NULL);

  CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER NOT NULL,
                              PS_SUPPKEY     INTEGER NOT NULL,
                              PS_AVAILQTY    INTEGER NOT NULL,
                              PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                              PS_COMMENT     VARCHAR(199) NOT NULL );

  CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL,
                              C_NAME        VARCHAR(25) NOT NULL,
                              C_ADDRESS     VARCHAR(40) NOT NULL,
                              C_NATIONKEY   INTEGER NOT NULL,
                              C_PHONE       CHAR(15) NOT NULL,
                              C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                              C_MKTSEGMENT  CHAR(10) NOT NULL,
                              C_COMMENT     VARCHAR(117) NOT NULL);

  CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                            O_CUSTKEY        INTEGER NOT NULL,
                            O_ORDERSTATUS    CHAR(1) NOT NULL,
                            O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                            O_ORDERDATE      DATE NOT NULL,
                            O_ORDERPRIORITY  CHAR(15) NOT NULL,
                            O_CLERK          CHAR(15) NOT NULL,
                            O_SHIPPRIORITY   INTEGER NOT NULL,
                            O_COMMENT        VARCHAR(79) NOT NULL);

  CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,
                              L_PARTKEY     INTEGER NOT NULL,
                              L_SUPPKEY     INTEGER NOT NULL,
                              L_LINENUMBER  INTEGER NOT NULL,
                              L_QUANTITY    DECIMAL(15,2) NOT NULL,
                              L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                              L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                              L_TAX         DECIMAL(15,2) NOT NULL,
                              L_RETURNFLAG  CHAR(1) NOT NULL,
                              L_LINESTATUS  CHAR(1) NOT NULL,
                              L_SHIPDATE    DATE NOT NULL,
                              L_COMMITDATE  DATE NOT NULL,
                              L_RECEIPTDATE DATE NOT NULL,
                              L_SHIPINSTRUCT CHAR(25) NOT NULL,
                              L_SHIPMODE     CHAR(10) NOT NULL,
                              L_COMMENT      VARCHAR(44) NOT NULL);

  ALTER TABLE PART ADD PRIMARY KEY (P_PARTKEY);
  ALTER TABLE SUPPLIER ADD PRIMARY KEY (S_SUPPKEY);
  ALTER TABLE PARTSUPP ADD PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY);
  ALTER TABLE CUSTOMER ADD PRIMARY KEY (C_CUSTKEY);
  ALTER TABLE ORDERS ADD PRIMARY KEY (O_ORDERKEY);
  ALTER TABLE LINEITEM ADD PRIMARY KEY (L_ORDERKEY, L_LINENUMBER);
  ALTER TABLE NATION ADD PRIMARY KEY (N_NATIONKEY);
  ALTER TABLE REGION ADD PRIMARY KEY (R_REGIONKEY);
EOF
echo "done"

echo -n "* Loading data..."
psql -q -U postgres 2>&1 > /dev/null <<EOF
  \COPY part     FROM '/project/data/setup/part.csv'     DELIMITER ',' CSV HEADER;
  \COPY region   FROM '/project/data/setup/region.csv'   DELIMITER ',' CSV HEADER;
  \COPY nation   FROM '/project/data/setup/nation.csv'   DELIMITER ',' CSV HEADER;
  \COPY supplier FROM '/project/data/setup/supplier.csv' DELIMITER ',' CSV HEADER;
  \COPY partsupp FROM '/project/data/setup/partsupp.csv' DELIMITER ',' CSV HEADER;
  \COPY customer FROM '/project/data/setup/customer.csv' DELIMITER ',' CSV HEADER;
  \COPY orders   FROM '/project/data/setup/orders.csv'   DELIMITER ',' CSV HEADER;
  \COPY lineitem FROM '/project/data/setup/lineitem.csv' DELIMITER ',' CSV HEADER;
EOF
echo "done"

echo -n "* Creating indexes and foreign keys..."
psql -q -U postgres 2>&1 > /dev/null <<EOF
  ALTER TABLE SUPPLIER ADD FOREIGN KEY (S_NATIONKEY) REFERENCES NATION(N_NATIONKEY);

  ALTER TABLE PARTSUPP ADD FOREIGN KEY (PS_PARTKEY) REFERENCES PART(P_PARTKEY);
  ALTER TABLE PARTSUPP ADD FOREIGN KEY (PS_SUPPKEY) REFERENCES SUPPLIER(S_SUPPKEY);

  ALTER TABLE CUSTOMER ADD FOREIGN KEY (C_NATIONKEY) REFERENCES NATION(N_NATIONKEY);

  ALTER TABLE ORDERS ADD FOREIGN KEY (O_CUSTKEY) REFERENCES CUSTOMER(C_CUSTKEY);

  ALTER TABLE LINEITEM ADD FOREIGN KEY (L_ORDERKEY) REFERENCES ORDERS(O_ORDERKEY);
  ALTER TABLE LINEITEM ADD FOREIGN KEY (L_PARTKEY,L_SUPPKEY) REFERENCES PARTSUPP(PS_PARTKEY,PS_SUPPKEY);

  ALTER TABLE NATION ADD FOREIGN KEY (N_REGIONKEY) REFERENCES REGION(R_REGIONKEY);

  CREATE INDEX IDX_SUPPLIER_NATION_KEY ON SUPPLIER (S_NATIONKEY);

  CREATE INDEX IDX_PARTSUPP_PARTKEY ON PARTSUPP (PS_PARTKEY);
  CREATE INDEX IDX_PARTSUPP_SUPPKEY ON PARTSUPP (PS_SUPPKEY);

  CREATE INDEX IDX_CUSTOMER_NATIONKEY ON CUSTOMER (C_NATIONKEY);

  CREATE INDEX IDX_ORDERS_CUSTKEY ON ORDERS (O_CUSTKEY);

  CREATE INDEX IDX_LINEITEM_ORDERKEY ON LINEITEM (L_ORDERKEY);
  CREATE INDEX IDX_LINEITEM_PART_SUPP ON LINEITEM (L_PARTKEY,L_SUPPKEY);

  CREATE INDEX IDX_NATION_REGIONKEY ON NATION (N_REGIONKEY);


  CREATE INDEX IDX_LINEITEM_SHIPDATE ON LINEITEM (L_SHIPDATE, L_DISCOUNT, L_QUANTITY);

  CREATE INDEX IDX_ORDERS_ORDERDATE ON ORDERS (O_ORDERDATE);

  ANALYZE;
EOF
echo "done"
