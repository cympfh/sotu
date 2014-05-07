all: annotate.html guide.html

annotate.html: template.html
	./u2annotator "" $@

guide.html: guide.md guide.css
	pandoc -s --css guide.css -i guide.md -o guide.html
