HOME = process.env.HOME
dir = process.argv[2] || "#{HOME}/Dropbox/tw/cat"
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
    ret.push {text: tw[i+1]} if tw[i] is '<text>'
    ret.push {icon: tw[i+1]} if tw[i] is '<icon>'
  ret

hs = (read h).map filter_text
fs = (read f).map filter_text

I = hs.length
process.assert fs.length is I

stat = (obj, label) ->
  futa = (x) -> Math.round(x * 1000) / 1000
  p = obj.tp / (obj.tp + obj.fp)
  r = obj.tp / (obj.tp + obj.tn)
  f = 2 / ((1/p) + (1/r))
  label_sp = label
  while label_sp.length < 11
    label_sp = label_sp + ' '
  console.log "| #{label_sp} | #{futa p} | #{futa r} | #{futa f} |"

relax = (s) ->
  if 0 <= s.indexOf target then target else ''

total_of = (ls) ->
  ls.filter ((o) -> o.text?)
    .map ((o) -> o.text)
    .join ','

find_icon = (tw, n) ->
  for i in [n+1 .. n+8]
    return tw[i].icon if tw[i]?.icon?
  tw[n].text

for target in ['null', 'yor', 'ai', 'odo', 'ika', 'haj']

  BS = {}
  BS.independent =
    tp: 0
    fp: 0
    tn: 0
  BS.total =
    tp: 0
    fp: 0
    tn: 0
  BS.icon8 =
    tp: 0
    fp: 0
    tn: 0

  for i in [0 ... I]
    htw = hs[i]
    ftw = fs[i]
    N = htw.length

    if ftw.length isnt N
      console.log i
      console.log '%j', htw
      console.log '%j', ftw
    process.assert (ftw.length is N)

    total = relax total_of ftw

    for n in [0 ... N]
      continue if not (htw[n].text?)
      ht = htw[n].text
      ft = relax ftw[n].text
      ++BS.independent.tp if ht is target and ft is target
      ++BS.independent.tn if ht is target and ft isnt target
      ++BS.independent.fp if ht isnt target and ft is target

      ++BS.total.tp if ht is target and total is target
      ++BS.total.tn if ht is target and total isnt target
      ++BS.total.fp if ht isnt target and total is target

      ft_over = find_icon ftw, n
      ++BS.icon8.tp if ht is target and ft_over is target
      ++BS.icon8.tn if ht is target and ft_over isnt target
      ++BS.icon8.fp if ht isnt target and ft_over is target

  console.log target
  stat BS.independent, "Independent"
  stat BS.total, "Total"
  stat BS.icon8, "Icon-8"
