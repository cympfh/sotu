#!/bin/bash

[ $# -ne 3 ] && echo './% DIR C G' && exit 0

PRINTF=./svm/svm-features.exe
CROSS=./svm/or-test.js

DIR=$1

C=$2
G=$3

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

cat /tmp/it.scaled  > /tmp/it.shuffled
lines=`wc -l /tmp/it.shuffled | awk '{print $1}'`
head -n $(( $lines * 2 / 3 )) /tmp/it.shuffled > /tmp/it.train
tail -n $(( $lines * 1 / 3 )) /tmp/it.shuffled > /tmp/it.test

MODEL=/tmp/it.model
svm-train -s 0 -t 2 -c $C -g $G /tmp/it.train $MODEL | tail -n2
svm-predict /tmp/it.test $MODEL /tmp/result

