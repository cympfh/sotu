#!/bin/bash

if ls ./svm/svm-train.exe ; then
  TRAIN=./svm/svm-train.exe
else
  TRAIN=./svm-train.exe
fi

EM=$1
FE=$2
HD=$3
./svm/svm-train.exe $EM $FE $HD | sort -R > /tmp/it.train
head -n 260 /tmp/it.train > /tmp/it.head
tail -n 21 /tmp/it.train > /tmp/it.tail
svm_learn /tmp/it.head /tmp/it.model
svm_classify -v 3 /tmp/it.tail /tmp/it.model /tmp/result
