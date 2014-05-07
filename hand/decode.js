fs = require('fs');

var ls =
  fs.readFileSync(process.argv[2], 'utf8').split('\n').slice(0, -1);

var code = 
  fs.readFileSync('/dev/stdin', 'utf8')
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
  'H' : "haj"
};

var cx = 0;
var flg = false;
for (var i=0; i < ls.length; ++i) {
  var l = ls[i];
  if (l === '__EOT__') {
    console.log(l);
  } else if (l === '<icon>') {
    console.log(l);
    flg = true;
  } else if (l === '</icon>') {
    console.log(l);
  } else if (l === '<text>') {
    console.log(l);
    flg = true;
  } else if (l === '</text>') {
    console.log(l);
  } else if (l === '<conj>') {
    console.log(l);
  } else if (l === '</conj>') {
    console.log(l);
  } else if (flg) {
    console.log(show[code[cx]]);
    flg = false;
    ++cx;
  } else {
    console.log(l);
  }
}

