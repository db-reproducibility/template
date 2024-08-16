#!/bin/bash

echo "runtime" > data/duckdb.csv
for FILE in `ls /project/queries/*.sql | sort -V`; do
  EXPERIMENT=`basename "$FILE"`
  echo -n "* Running experiment '$EXPERIMENT'..."
  # Run the experiment and measure the time
  OUTPUT=`duckdb data/duckdb.db -init <(printf ".timer on\n.mode trash") < "$FILE"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "real \S+" \
                       | tail -n1 | sed 's/real //'`
  # Print the time and write it to the results file
  echo -e "done\tTime: $TIME"
  echo "$TIME" >> data/duckdb.csv
done
