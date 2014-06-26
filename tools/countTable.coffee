fs = require 'fs'

readTwo = (line) ->
  re = /^\s*([^\s]*)\s+([^\s]*)\s*$/
  res = line.match(re)
  if res is null
    null
  else
    [res[1], res[2]]

inc = (tbl, k) ->
  if tbl?[k]?
    ++tbl[k]
  else
    tbl[k] = 1

tp = {}
fp = {}
fn = {}

fs.readFile '/dev/stdin', 'utf8', (err, data) ->

  data.split('\n').slice(0, -1)
    .forEach (line) ->
      [t, p] = readTwo(line)
      if t is p
        inc tp, t
      else
        inc fp, p
        inc fn, t

  for k of tp
    tp_ = if tp[k] then tp[k] else 0
    fp_ = if fp[k] then fp[k] else 0
    fn_ = if fn[k] then fn[k] else 0

    prec = tp_ / (tp_ + fp_)
    rec = tp_ / (tp_ + fn_)
    f1 = 2 / (1 / prec + 1 / rec)
    console.log '| %s | %d | %d | %d |', k, prec, rec, f1

