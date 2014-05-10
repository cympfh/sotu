all: svm-train.exe

%.exe: %.hs
	ghc -O3 $^ -o $@

clean:
	rm *.exe
