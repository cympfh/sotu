HOME = process.env.HOME
dir = process.argv[2] || "#{HOME}/Dropbox/tw/emem"
h = "#{dir}/h"
f = "#{dir}/f"

fs = require 'fs'

read = (file) ->
  fs.readFileSync file, 'utf8'
     .split '__EOT__\n'
     .map (tw) -> (tw.split '\n').slice 0, -1
     .slice 0, -1

filter_text = (tw) ->
  ret = []
  N = tw.length
  for i in [0 ... N]
    ret.push tw[i+1] if tw[i] is '<text>'
  ret

hs = (read h).map filter_text
fs = (read f).map filter_text

I = hs.length
process.assert fs.length is I

BS = {}
BS.independent =
  tp: 0
  fp: 0
  tn: 0
BS.total =
  tp: 0
  fp: 0
  tn: 0

stat = (obj) ->
  futa = (x) -> (x * 1000 | 0) / 1000
  p = obj.tp / (obj.tp + obj.fp)
  r = obj.tp / (obj.tp + obj.tn)
  f = 2 / ((1/p) + (1/r))
  console.log "| #{futa p} | #{futa r} | #{futa f} |"

target = 'yor'

relax = (s) ->
  if 0 <= s.indexOf target then target else ''

total_of = (ls) ->
  if 0 <= (ls.join '').indexOf target then target else ''

for i in [0 ... I]
  htw = hs[i]
  ftw = fs[i]
  N = htw.length
  process.assert ftw.length is N

  total = total_of ftw

  for n in [0 ... N]
    ht = htw[n]
    ft = relax ftw[n]
    ++BS.independent.tp if ht is target and ft is target
    ++BS.independent.tn if ht is target and ft isnt target
    ++BS.independent.fp if ht isnt target and ft is target

    ++BS.total.tp if ht is target and total is target
    ++BS.total.tn if ht is target and total isnt target
    ++BS.total.fp if ht isnt target and total is target

stat BS.independent
stat BS.total
