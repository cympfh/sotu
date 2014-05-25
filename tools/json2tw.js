var jfile = process.argv[2]
  , tw = require(jfile)
  ;
for (var i=0; i<tw.length; ++i) {
  text = tw[i].text;
  if (text.indexOf('RT') === 0) continue;
  text = text.replace(/\r\n/g, ' ').replace(/\n/g, ' ').replace(/\r/g, '');
  text = text.replace(/(#|＃)[^ 　]*/g, ' ');
  text = text.replace(/@[^ 　]*/g, ' ');
  text = text.replace(/http[:a-zA-Z0-9\-_\/\.\:]*/g, ' ');
  text = text.trim();
  console.log(text);
}
