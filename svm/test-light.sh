#!/bin/bash

if ls ./svm/svm-train.exe ; then
  TRAIN=./svm/svm-train.exe
else
  TRAIN=./svm-train.exe
fi

EM=$1
F1=$2
H1=$3
F2=$4
H2=$5

${TRAIN} $EM $F1 $H1 > /tmp/it.train
${TRAIN} $EM $F2 $H2 > /tmp/it.train2

svm_learn /tmp/it.train /tmp/it.model
svm_classify -v 3 /tmp/it.train2 /tmp/it.model /tmp/result
