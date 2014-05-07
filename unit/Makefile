all: unit.exe

%.exe: %.hs
	ghc -O3 $^ -o $@

clean:
	rm -f output.txt  unit.exe  unit.hi  unit.o
