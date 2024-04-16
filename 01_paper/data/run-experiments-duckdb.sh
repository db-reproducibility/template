#!/bin/bash

test -f results.csv || echo "experiment, time" > results.csv
for EXPERIMENT in /data/experiments/duckdb_*.sql; do
  echo "Running experiment $EXPERIMENT"
  # Run the experiment and measure the time
  OUTPUT=`duckdb < "$EXPERIMENT"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "real \S+" \
                       | tail -n1 | sed 's/real //'`
  # Print the time and write it to the results file
  echo "Time: $TIME"
  echo "$EXPERIMENT, $TIME" >> results.csv
done
