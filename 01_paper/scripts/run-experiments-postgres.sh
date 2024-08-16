#!/bin/bash

echo "runtime" > data/postgres.csv
for FILE in `ls /project/queries/*.sql | sort -V`; do
  EXPERIMENT=`basename "$FILE"`
  echo -n "* Running experiment '$EXPERIMENT'..."
  # Run the experiment and measure the time
  OUTPUT=`psql -U postgres -c "\timing on" -f "$FILE"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "Time: \S+" \
                       | tail -n1 | sed 's/Time: //'`
  # Print the time and write it to the results file
  echo -e "done\tTime: $TIME"
  echo "$TIME" >> data/postgres.csv
done
