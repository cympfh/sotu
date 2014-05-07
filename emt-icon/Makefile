all: icon.lex test

test: emt-icon.exe sample_inputs icon.lex
	./emt-icon.exe icon.lex sample_inputs | tee sample_outputs

icon.lex: train.exe
	./train.exe ../tweets/tweet0.txt ../tweets/tweet0-new.hand.txt > $@

%.exe: %.hs
	ghc -O3 $^ -o $@

.PHONY: clean

clean:
	rm -f *.exe icon.lex
