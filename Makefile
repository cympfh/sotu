all:
	cat Makefile

# 素tweet -> units
units:
	# split into units
	cd detect-icon/; ./detect $(TWEETS) /tmp/icon
	./unit/unit.exe < /tmp/icon > /tmp/unit
	# detect-icon/tag2line で
	# </icon>__EOT__ の時に間に改行挟みまくっちゃう
	sed -i -s '/^$$/d' $(OUTPUT)

# units -> features
features:
	runghc ./features.hs < $(UNITS) > /tmp/features

