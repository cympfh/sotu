test: svm-train

all:
	cat Makefile

# 素tweet -> units
units:
	# split into units
	cd detect-icon/; ./detect $(TWEETS) /tmp/icon
	./unit/unit.exe < /tmp/icon > $(OUTPUT)
	# detect-icon/tag2line で
	# </icon>__EOT__ の時に間に改行挟みまくっちゃう
	sed -i -s '/^$$/d' $(OUTPUT)

# units -> features
features:
	runghc ./features.hs < $(UNITS) > $(OUTPUT)

FEATURES=~/Dropbox/tw/feature08.txt
HAND=~/Dropbox/tw/hand08.txt

svm-train:
	./svm/svm-train.sh "null" $(FEATURES) $(HAND) | egrep "Acc|Prec"
	./svm/svm-train.sh "yor" $(FEATURES) $(HAND) | egrep "Acc|Prec"

