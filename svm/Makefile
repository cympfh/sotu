all: svm-features.exe

svm-features.exe: svm-features.hs It.hs PrintF.hs Em.hs Conj.hs
	ghc -O3 $^ -o $@

clean:
	rm *.exe *.hi *.o
