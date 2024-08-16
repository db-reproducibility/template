#!/bin/bash

mkdir -p /project/data/results
echo "runtime" > /project/data/results/postgres.csv
for FILE in `ls /project/queries/*.sql | sort -V`; do
  EXPERIMENT=`basename "$FILE"`
  echo -n "* Running '$EXPERIMENT'..."
  # Run the experiment and measure the time
  OUTPUT=`psql -U postgres -c "\timing on" -f "$FILE"`
  # Extract the time from the output
  TIME=`echo "$OUTPUT" | grep -o -E "Time: \S+" \
                       | tail -n1 | sed 's/Time: //'`
  # Print the time and write it to the results file
  echo -e "done\tTime: $TIME"
  echo "$TIME" >> /project/data/results/postgres.csv
done
