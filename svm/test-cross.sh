#!/bin/bash

# 2014年  8月 28日 木曜日 05:59:47 JST
# null: 0.4659090909090909 0.36936936936936937 0.4120603015075377
# yor: 0.7166666666666667 0.7510917030567685 0.7334754797441365
# ai: 0.38461538461538464 0.2777777777777778 0.3225806451612903
# odo: 0.125 0.14285714285714285 0.13333333333333333
# ika: 0 0 0
# haj: 0 0 0

head $0 && exit 0

PRINTF=./svm/svm-features.exe
CROSS=./svm/or-test.js

DIR=$1

C=$2
S=$3

$PRINTF $DIR > /tmp/it.train
# svm-scale /tmp/it.train > /tmp/it.scaled
# mv /tmp/it.scaled /tmp/it.train

node $CROSS /tmp/it.train /tmp $C $S

# svm-train -t 2 -v 10 -c 32 -g 0.0078 /tmp/it.scaled

# GRIDTOOL=$HOME/Tools/libsvm-3.18/tools/grid.py
# result=`$GRIDTOOL -v 10 /tmp/it.scaled | tail -1`
# c=`echo $result | cut -d' ' -f1`
# g=`echo $result | cut -d' ' -f2`
# svm-train -t 2 -v 10 -c $c -g $g /tmp/it.scaled
