all: test
	
test: unit.exe
	./unit.exe < ../detect-icon/output.txt > ./output.txt

%.exe: %.hs
	ghc -O3 $^ -o $@

clean:
	rm output.txt  unit.exe  unit.hi  unit.o
