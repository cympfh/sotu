#!/bin/bash

if ls ./svm/svm-train.exe ; then
  TRAIN=./svm/svm-train.exe
else
  TRAIN=./svm-train.exe
fi

EM=$1
FE=$2
HD=$3
FE2=$4
HD2=$5

./svm/svm-train.exe $EM $FE $HD | sort -R > /tmp/it.train
./svm/svm-train.exe $EM $FE2 $HD2 | sort -R > /tmp/it.train2

svm_learn /tmp/it.train /tmp/it.model
svm_classify -v 3 /tmp/it.train2 /tmp/it.model /tmp/result
