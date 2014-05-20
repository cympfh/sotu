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
