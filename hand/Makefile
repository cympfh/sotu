all: annotate.html guide.html

annotate.html: template.html
	./u2annotator "" $@

guide.html: guide.md
	pandoc -s -i guide.md -o guide.html
