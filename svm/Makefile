all: svm-train.exe

svm-train.exe: svm-train.hs It.hs PrintF.hs Em.hs Conj.hs
	ghc -O3 $^ -o $@

clean:
	rm *.exe
