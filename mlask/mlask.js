#!/usr/local/bin/node

var fs = require('fs');

function readFile(fn) {
  return fs.readFileSync(fn, 'utf8');
}

// directory of lexicons
var pref = (process.argv[2] ? process.argv[2] : "") + "./emotions/";

var emoTypes =
  [ 'awa', 'haj', 'ika', 'iya', 'kow'
  , 'odo', 'suk', 'tak', 'yas', 'yor'];

var emotions =
  ['aware' , 'haji' , 'ikari' , 'iya' , 'kowa' , 'odoroki' , 'suki' , 'takaburi' , 'yasu' , 'yorokobi']
  .map(function(fname, i) {
    return {
        tag : emoTypes[i]
      , ls  : readFile(pref + fname+'_uncoded.txt')
                .split('\n').slice(0, -1)
    };
  });

var hash_cvs = {
    'suk' : ['iya']
  , 'ika' : ['yas']
  , 'kow' : ['yas']
  , 'yas' : ['ika','tak','odo','haj','kow']
  , 'iya' : ['yor','suk']
  , 'awa' : ['suk','yor','tak','odo','haj']
  , 'tak' : ['yas','awa']
  , 'odo' : ['yas','awa']
  , 'haj' : ['yas','awa']
  , 'yor' : ['iya']
};

var cvs_type1 = /あまり|そんなに|ぜったい|まったく|すこしも|いまひと|いまひとつも|ちょっとも|ちっとも|いまいち|まさか|そんな|ぜんぜん|そもそも|すら|とても|余り|絶対|ゼッタイ|全く|マッタク|少しも|今ひとつ|今一つ|今一|今いち|全然/
  , cvs_type2 = /あまりない|そんなにない|ぜったいない|まったくない|すこしもない|いまひとつない|いまひとつもない|ちょっともない|ちっともない|いまいちない|ぜんぜんない|そもそもない|といえない|とはいえない|と思わない|とは思わない|と思えない|とは思えない|とすら思えない|てはいけない|ちゃいけない|じゃいけない|てはだめ|ちゃだめ|じゃだめ|てはいかん|てはあかん|ちゃいかん|じゃいかん|じゃあかん|じゃない|ちゃあかん|なくていい|なくてOK|なくてＯＫ|なくて大丈夫|なくて問題ない|なくて結構|なくてもいい|なくてもOK|なくても大丈夫|なくても問題ない|なくても結構|く思わない|く思えない|もんか|ものか|わけではない|わけじゃない|こともない|ことはない|わけない|わけがない|わけはない|わけもない|わけか|わけにはいかない|わけにはいくまい|わけにもいかない|余りない|ゼッタイない|絶対ない|全くない|少しもない|今一つない|今ひとつない|今一つもない|今ひとつもない|今いちない|今一ない|全然ない|と言えない|とは言えない|ては行けない|ちゃ行けない|じゃ行けない|ては行かん|ちゃ行かん|じゃ行かん|じゃあかん|ちゃあかん|なくて良い|なくてOK|なくてＯＫ|なくても良い|訳ではない|でわない|ではない|でゎない|訳じゃない|訳ない|訳がない|訳はない|訳もない|訳か|訳にはいかない|訳には行かない|訳にはいくまい|訳にも行かない/;

function test(line) {
  line = line.replace(/\!/g, '！')
             .replace(/\?/g, '？')
             .trim();

  var ret = [];

  // emotion DB
  for (var i=0; i<emotions.length; ++i) {
    var ls = emotions[i].ls;
    var tag = emotions[i].tag;
    for (var j=0; j<ls.length; ++j) {
      var idx = line.indexOf(ls[j]);
      if (idx !== -1) {
        var cvs_flg = false;

        var r = line.match(cvs_type1);
        if (r && r.index < idx) cvs_flg = true;

        if (!cvs_flg) r = line.match(cvs_type2);
        if (r && r.index > idx) cvs_flg = true;

        if (cvs_flg) {
          ret = ret.concat(hash_cvs[tag]);
        } else {
          ret = ret.concat(tag);
        }
      }
    }
  }
  return nub(ret);
}

function nub(ls) {
  var ret = [];
  for (var i=0; i<ls.length; ++i) {
    var x = ls[i];
    if (ret.indexOf(x) === -1) {
      ret.push(x);
    }
  }
  return ret;
}

(function main() {
  readFile('/dev/stdin').split('\n').slice(0, -1)
    .forEach(function(l) {
      var ls = test(l);
      if (ls.length === 0) {
        console.log('null');
      } else {
        console.log(ls.join(' '));
      }
    });
}());
