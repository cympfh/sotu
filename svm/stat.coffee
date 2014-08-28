#!/usr/bin/env coffee

f0 = process.argv[2] || '/tmp/result'
f1 = process.argv[3] || '/tmp/it.test'

fs = require 'fs'
read = (fn) ->
  fs.readFileSync fn, 'utf8'
    .split '\n'
    .slice 0, -1

ls0 = read f0
ls1 = read f1
  .map (l) -> (l.split ' ')[0]

alias =
  '1': 'null'
  '2': 'yor'
  '3': 'ai'
  '4': 'odo'
  '5': 'ika'
  '6': 'haj'

for target in ['1', '2', '3', '4', '5', '6']

  tp = 0
  fp = 0
  tn = 0

  I = ls0.length
  process.assert ls1.length is I

  for i in [0 ... I]
    predict = ls0[i]
    answer = ls1[i]
    ++tp if predict is target and answer is target
    ++fp if predict is target and answer isnt target
    ++tn if predict isnt target and answer is target

  prec = tp / (tp + fp)
  rec = tp / (tp + tn)
  f1 = 2 / (1 / prec + 1 / rec)

  console.log "| #{alias[target]} | #{prec} | #{rec} | #{f1}|"

