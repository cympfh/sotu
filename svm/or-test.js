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
    , N = len * 0.9 | 0 // for train

    , svms = {}
    ;

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

  // train
  for (var e in labelss) {
    console.warn('training for ' + e);
    svms[e] = new SVM();
    svms[e].train(datum.slice(0, N),
                  labelss[e].slice(0, N),
                  options);
    // fs.writeFile(pref + '/' + e + '.json', JSON.stringify(asvm.toJSON(), null, 2));
  }

  console.warn('tagging and counting');

  // tagging
  var ms = {};
  for (var e in labelss) {
    ms[e] = svms[e].margins(datum.slice(N, len));
  }
  result = map_max(ms);

  // count and display result
  count(result);

  function count(result) {
    for (var e in labelss) {
      var tp = 0
        , fn = 0
        , fp = 0
        ;
      for (var i=N; i < len; ++i) {
        var correct = labels[i]
          , answer = result[i-N]
          ;
        if (answer === e && correct === e) ++tp;
        if (answer === e && correct !== e) ++fp;
        if (answer !== e && correct === e) ++fn;
      }
      console.log('%s: %d %d %d', e, 
          tp/(tp+fp),
          tp/(tp+fn),
          2 / ( (tp+fp) / tp  + (tp+fn) / tp));
    }
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
