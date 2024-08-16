#!/bin/bash

pushd /project/paper > /dev/null
latexmk\
  -outdir=/project/data \
  -pdf \
  -interaction=nonstopmode \
  -shell-escape \
  -synctex=1 \
  -f \
  paper.tex
popd > /dev/null
