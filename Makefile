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

DIR=~/Dropbox/tw/emem/
FILE = log/`date "+%m%d-%H%M"`
dosvm:
	./svm/test-cross-lib.sh $(DIR) "0.98" "0.3"
	echo "./svm/test-cross-lib.sh $(DIR)" > $(FILE)
	coffee ./svm/stat.coffee /tmp/result /tmp/it.test >> $(FILE)
	cat $(FILE)
