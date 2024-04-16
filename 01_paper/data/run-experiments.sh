#!/bin/bash

test -f results.csv || echo "experiment, time" > results.csv
for EXPERIMENT in /data/experiments/pg_*.sql; do
  echo "Running experiment $EXPERIMENT"
  # Run the experiment and measure the time
  OUTPUT=`psql -U postgres -c "\timing on" -f "$EXPERIMENT"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "Time: \S+" \
                       | tail -n1 | sed 's/Time: //'`
  # Print the time and write it to the results file
  echo "Time: $TIME"
  echo "$EXPERIMENT, $TIME" >> results.csv
done
