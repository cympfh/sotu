var fs = require('fs')
  , SVM = require('svm').SVM
  , trainFile = process.argv[2]
  , testFile = process.argv[3]
  , svmC = +process.argv[4] || 0.99
  , svmRbfsigma = +process.argv[5] || 0.6
  , options = { kernel : 'rbf', C: svmC, rbfsigma: svmRbfsigma }
  ;

console.warn(options);

tr = fs.readFileSync(trainFile, 'utf8').split('\n').slice(0, -1);
te = fs.readFileSync(testFile, 'utf8').split('\n').slice(0, -1);

tr_a = read(tr);
tr_labelss = tr_a[0];
tr_datum = tr_a[2];

svms = {};
for (e in tr_labelss) {
  console.warn('training for ' + e);
  svms[e] = new SVM();
  svms[e].train(tr_datum, tr_labelss[e], options);
}

te_a = read(te);
te_labels = te_a[1];
te_datum = te_a[2];

ms = {};
for (var e in tr_labelss) {
  ms[e] = svms[e].margins(te_datum);
}
result = map_max(ms);

tp = {};
fp = {};
fn = {};

for (e in tr_labelss) {
  if (!(e in tp)) { tp[e] = fn[e] = fp[e] = 0; }
  for (i=0; i < result.length; ++i) {
    var correct = te_labels[i]
      , answer = result[i] ;
    if (answer === e && correct === e) ++tp[e];
    if (answer === e && correct !== e) ++fp[e];
    if (answer !== e && correct === e) ++fn[e];
  }
}

for (var e in tr_labelss) {
  console.log('%s: %d %d %d', e, 
      tp[e]/(tp[e]+fp[e]),
      tp[e]/(tp[e]+fn[e]),
      2 / ( (tp[e]+fp[e]) / tp[e]  + (tp[e]+fn[e]) / tp[e]));
}

function read(ls) {
  var labelss = {
          'null': [],
          'yor': [],
          'ai' : [],
          'odo': [],
          'ika': [],
          'haj': []
    }
    , labels = []
    , datum = []
    ;
  for (var i=0, len=ls.length; i < len; ++i) {
    var l = ls[i];
    var ws = l.split(' ');

    push(ws[0]);

    var d =
      ws.slice(1).map(function(w) {
        return w.split(':')[1] | 0;
      });

    datum.push(d);
  }
  return [labelss, labels, datum];

  function push(label) {
    if (!(label in labelss)) {
      console.warn('unknown label: ' + label);
      process.exit(1);
    }
    for (var e in labelss) {
      labelss[e].push( (e === label) ? 1 : -1 );
    }
    labels.push(label);
  }
}

  function map_max(obj) {

    var ret = [];
    for (var i=0;; ++i) {

      var ml, mx = -1e10;
      for (var e in obj) {
        if (!(i in obj[e])) return ret;
        if (mx < obj[e][i]) { mx = obj[e][i]; ml = e; }
      }
      ret.push(ml);
    }
  }
