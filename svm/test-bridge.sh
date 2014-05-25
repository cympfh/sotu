#!/bin/bash

PRINTF=./svm/svm-features.exe
BRIDGE=./svm/or-bridge.js

FROMF=$1/f
FROMH=$1/h
TOF=$2/f
TOH=$2/h

C=$3
S=$4

$PRINTF $FROMF $FROMH > /tmp/it.train
mv /tmp/it.train /tmp/from.train
$PRINTF $TOF $TOH > /tmp/it.train

node $BRIDGE /tmp/from.train /tmp/it.train $C $S

