#!/bin/bash

PRINTF=./svm/svm-features.exe
CROSS=./svm/or-test.js

DIR=$1
if [ -z "$DIR" ]; then
  DIR=$HOME/Dropbox/tw/cat_balanced3
fi

$PRINTF $DIR > /tmp/it.raw
sed \
  -e 's/null/1/g' \
  -e 's/yor/2/g' \
  -e 's/ai/3/g' \
  -e 's/odo/4/g' \
  -e 's/ika/5/g' \
  -e 's/haj/6/g' \
  -e '/^#/d' \
  /tmp/it.raw > /tmp/it.labeled
svm-scale /tmp/it.labeled > /tmp/it.scaled

TRAINDAT=/tmp/it.train
TESTDAT=/tmp/it.test

cat /tmp/it.scaled | sort -R > /tmp/it.shuffled
lines=`wc -l /tmp/it.shuffled | awk '{print $1}'`
head -n $(( $lines * 2 / 3 )) /tmp/it.shuffled > $TRAINDAT
head -n $(( $lines * 1 / 3 )) /tmp/it.shuffled > $TESTDAT

MODEL=/tmp/it.model

GRIDTOOL=$HOME/Tools/libsvm-3.18/tools/grid.py
result=`$GRIDTOOL -v 10 $TRAINDAT | tail -1`
c=`echo $result | cut -d' ' -f1`
g=`echo $result | cut -d' ' -f2`
svm-train -t 2 -c $c -g $g $TRAINDAT $MODEL
svm-predict $TESTDAT $MODEL /tmp/result

cat /tmp/it.test | cut -d' ' -f1 > /tmp/it.test.f1
paste /tmp/it.test.f1 /tmp/result > /tmp/table
coffee ./tools/countTable.coffee < /tmp/table
