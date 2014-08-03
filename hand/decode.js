fs = require('fs');

var ls =
  fs.readFileSync(process.argv[2], 'utf8').split('\n').slice(0, -1);

var code = 
  fs.readFileSync('/dev/stdin', 'utf8')
    .replace(/z/g, 'NU')
    .replace(/x/g, 'UN')
    .replace(/w/g, 'UUUUUUUU')
    .replace(/v/g, 'UUUU')
    .replace(/u/g, 'UU')
    .replace(/m/g, 'NNNN')
    .replace(/n/g, 'NN')
    .replace(/t/g, 'YYYY')
    .replace(/y/g, 'YY')
    .replace(/a/g, 'AA')
    .replace(/o/g, 'OO')
    .replace(/i/g, 'II')
    .replace(/h/g, 'HH')
    ;

var show = {
  'U' : "undefined",
  'N' : "null",
  'Y' : "yor",
  'A' : "ai",
  'O' : "odo",
  'I' : "ika",
  'H' : "haj",
};

var idx = {
  'U' : 0,
  'N' : 1,
  'Y' : 2,
  'A' : 3,
  'O' : 4,
  'I' : 5,
  'H' : 6,
};


var average = [];
for (var i=0; i<7; ++i) average[i] = 0;
var emline = [];
for (var i=0; i<7; ++i) emline[i] = 0;

var cx = 0;
var flg = false;
for (var i=0; i < ls.length; ++i) {
  var l = ls[i];
  if (l === '__EOT__') {
    console.log(l);
    average = add(average, norm(emline))
    for (var k=0; k<7; ++k) emline[k] = 0;
  } else if (l === '<icon>') {
    console.log(l);
    flg = true;
  } else if (l === '</icon>') {
    if (flg === true) { // 消費されなかった
      flg = false;
      console.log(show[code[cx]]);
      ++cx;
    }
    console.log(l);
  } else if (l === '<text>') {
    console.log(l);
    flg = true;
  } else if (l === '</text>') {
    if (flg === true) { // 消費されなかった
      flg = false;
      console.log(show[code[cx]]);
      ++cx;
    }
    console.log(l);
  } else if (l === '<conj>') {
    console.log(l);
  } else if (l === '</conj>') {
    console.log(l);
  } else if (flg) {
    console.log(show[code[cx]]);
    emline[idx[code[cx]]]++;
    flg = false;
    ++cx;
  } else {
    console.log(l);
  }
}

console.warn(norm(average));

function add(ls1, ls2) {
  var ret = [];
  for (var i=0; i<ls1.length; ++i) ret[i] = ls1[i] + ls2[i];
  return ret;
}

function norm(ls) {
  var total = 0;
  for (var i=0; i<ls.length; ++i) total += ls[i];
  return ls.map(function(x){return x/total});
}
