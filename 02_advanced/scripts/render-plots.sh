#!/bin/bash

pushd paper > /dev/null

gnuplot <<EOF
# configure output
set terminal latex
set output 'figures/comparison.tex'

# setup bar chart
set style data histograms
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtics rotate by -45
set yrange [0:*]
set ylabel "Time (s)"
set xlabel "Experiment"

# plot from ../data/results.csv
plot '../data/results.csv' using 3:xtic(2) ti col lc rgb "blue"
EOF

popd > /dev/null
