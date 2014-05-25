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

light:
	./svm/test-light.sh "null" $(F1) $(H1) $(F2) $(H2) | tail -n 2
	./svm/test-light.sh "yor" $(F1) $(H1) $(F2) $(H2) | tail -n 2
	./svm/test-light.sh "ika" $(F1) $(H1) $(F2) $(H2) | tail -n 2

