#!/bin/bash

if ls ./svm/svm-train.exe ; then
  TRAIN=./svm/svm-train.exe
else
  TRAIN=./svm-train.exe
fi

EM=$1
FE=$2
HD=$3
${TRAIN} $EM $FE $HD > /tmp/it.train
svm-scale /tmp/it.train > /tmp/it.scaled
svm-train -t 2 -v 10 -c 32 -g 0.0078 /tmp/it.scaled

if false; then
  GRIDTOOL=$HOME/Tools/libsvm-3.18/tools/grid.py
  result=`$GRIDTOOL -v 10 /tmp/it.scaled | tail -1`
  c=`echo $result | cut -d' ' -f1`
  g=`echo $result | cut -d' ' -f2`
  svm-train -t 2 -v 10 -c $c -g $g /tmp/it.scaled
fi
