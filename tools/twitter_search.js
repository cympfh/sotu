/*
 * ntwitter で search 使うだけ
 * see also: https://dev.twitter.com/docs/api/1.1/get/search/tweets
 */

var me = require(process.env.HOME+'/Dropbox/node/setting.json').users.sympf
  , tw = new require("ntwitter")(me)
  ;

var word = process.argv[2] || "#イライラ" // search word (UTF-8)
  , count = process.argv[3] || 1000 // num of tweets
  , lang = "ja" // japanese
  , type = "recent" // mixed | recent | popular
  ;

// since max of count = 100, do loop until required count

(function main() {

  var result = [];
  get(count, false);

  // search (max 100 tweets once) until count
  function get(count, max_id) {
    var options = { q: word, count: count, lang: lang, result_type: "recent" };
    if (max_id) {
      options.max_id = max_id;
    }
    tw.get( "https://api.twitter.com/1.1/search/tweets.json"
          , options
          , function (err, data) {
              if (err) {
                console.log(err);
                process.exit(1);
              }
              data = data.statuses;
              result = result.concat(data);
              count -= data.length;

              if (data.length < Math.min(count, 100)) {
                end(result);
              } else if (count > 0) {
                // loop
                get(count, data[data.length-1].id_str);
              } else {
                // base
                end(result);
              }
          });
  }

  function end(result) {
    result = result.filter(not_bot);
    console.log('%j', result);
  }

  function not_bot(tw) {
    var s = tw.source;
    var b = /twittbot|ぼっと|makebot|ツール|tool|動画|Button/.test(s);
    return !b;
  }

}());
