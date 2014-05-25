var fs = require('fs')
  , SVM = require('svm').SVM
  , trainFile = process.argv[2]
  , pref = process.argv[3]
  , svmC = +process.argv[4] || 0.99
  , svmRbfsigma = +process.argv[5] || 0.6
  , options = { kernel : 'rbf', C: svmC, rbfsigma: svmRbfsigma }
  ;

console.warn(options);

fs.readFile(trainFile, 'utf8', function(err, datum) {
  main( datum.split('\n').slice(0, -1) );
});

function main(ls) {
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

    , len = ls.length

    , svms = {}
    ;

  tp = {};
  fn = {};
  fp = {};

  // read
  for (var i=0; i < len; ++i) {
    var l = ls[i];
    var ws = l.split(' ');

    push(ws[0]);

    var d =
      ws.slice(1).map(function(w) {
        return w.split(':')[1] | 0;
      });

    datum.push(d);
  }

  var K = 3;
  for (var k=0; k < K; ++k) {
    console.warn(k);
    var k1 = k * len / K | 0
      , k2 = (k+1) * len / K | 0;
    tr_datum = datum.slice(0, k1).concat(datum.slice(k2, len));
    tr_labelss = {};
    for (var e in labelss) {
      tr_labelss[e] = labelss[e].slice(0, k1).concat(labelss[e].slice(k2, len));
    }

    te_datum = datum.slice(k1, k2);
    te_labelss = {};
    for (var e in labelss) {
      te_labelss[e] = labelss[e].slice(k1, k2);
    }

    // train
    for (var e in labelss) {
      console.warn('training for ' + e);
      svms[e] = new SVM();
      svms[e].train(tr_datum, tr_labelss[e], options);
      // fs.writeFile(pref + '/' + e + '.json', JSON.stringify(asvm.toJSON(), null, 2));
    }
    console.warn('tagging and counting');

    // tagging
    var ms = {};
    for (var e in labelss) {
      ms[e] = svms[e].margins(te_datum);
    }
    result = map_max(ms);

    for (var e in labelss) {
      if (!(e in tp)) {
        tp[e] = fn[e] = fp[e] = 0;
      }
      for (var i=0; i < result.length; ++i) {
        var correct = labels[i + k1]
          , answer = result[i]
          ;
        if (answer === e && correct === e) ++tp[e];
        if (answer === e && correct !== e) ++fp[e];
        if (answer !== e && correct === e) ++fn[e];
      }
    }
  }

  for (var e in labelss) {
    console.log('%s: %d %d %d', e, 
        tp[e]/(tp[e]+fp[e]),
        tp[e]/(tp[e]+fn[e]),
        2 / ( (tp[e]+fp[e]) / tp[e]  + (tp[e]+fn[e]) / tp[e]));
  }

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

  // {"x": [1,2,3], "y": [2,1,5]} -> ["y", "x", "y"]
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

}
