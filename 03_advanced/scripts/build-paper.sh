#!/bin/bash

mkdir -p /project/data/paper
pushd /project/paper > /dev/null
latexmk\
  -outdir=/project/data/paper \
  -pdf \
  -interaction=nonstopmode \
  -shell-escape \
  -synctex=1 \
  -f \
  paper.tex
popd > /dev/null
