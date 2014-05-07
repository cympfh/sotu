all: icon.lex

icon.lex: train.exe
	./train.exe ../tweets/tweet0.txt ../tweets/tweet0-new.hand.txt > $@

%.exe: %.hs
	ghc -O3 $^ -o $@

.PHONY: clean

clean:
	rm -f *.exe icon.lex
