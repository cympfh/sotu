#!/bin/bash

PRINTF=./svm/svm-features.exe
BRIDGE=./svm/or-bridge.js

FROM=$1
TO=$2

C=$3
S=$4

$PRINTF $FROM > /tmp/it.train
mv /tmp/it.train /tmp/from.train
$PRINTF $TO > /tmp/it.train

node $BRIDGE /tmp/from.train /tmp/it.train $C $S

