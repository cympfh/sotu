all: unit.exe

unit.exe: unit.hs Punc.hs Mecab.hs
	ghc -O3 $^ -o $@

clean:
	rm -f output.txt  unit.exe  unit.hi  unit.o
