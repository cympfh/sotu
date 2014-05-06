ツイートデータを、適当に区切って、XML風な何かにした tweets.txt
から、手で感情をアノテートする。
ここで感情とは

- null
- yor
- ai
- odo
- ika
- haj

の以上。

アノテートの結果が、annotate.*.txt で、アノテーターはどちらも私。
ただし作業にはおよそ4ヶ月ほど間が空いてるので別人であると私は考えている。

集計を取るのが count.hs で、結果がoutput。

Textについて、annotate.old.txtではnullでannotate.new.txtではyorであったのがn個あったとき、

    (Text, null, yor, n)

みたいに書かれてるはず
