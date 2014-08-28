#!/bin/bash

PRINTF=./svm/svm-features.exe
CROSS=./svm/or-test.js

DIR=$1

C=$2
S=$3

echo "./svm/test-cross.sh ${DIR} ${C} ${S}"

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
