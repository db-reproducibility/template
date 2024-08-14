#!/bin/bash

test -f results.csv || echo "dbms, experiment, time" > results.csv
for EXPERIMENT in `ls /data/queries/*.sql | sort -V`; do
  echo -n "* Running experiment $EXPERIMENT..."
  # Run the experiment and measure the time
  OUTPUT=`duckdb duckdb.db -init <(printf ".timer on\n.mode trash") < "$EXPERIMENT"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "real \S+" \
                       | tail -n1 | sed 's/real //'`
  # Print the time and write it to the results file
  echo -e "done\tTime: $TIME"
  echo "duckdb, $EXPERIMENT, $TIME" >> results.csv
done
