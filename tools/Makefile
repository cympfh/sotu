test: napsac50.exe
	./$^ ~/Dropbox/tw/cat ~/Dropbox/tw/cat_balanced/

all: count.exe napsac50.exe

%.exe: %.hs
	ghc -O3 $^ -o $@

clean:
	rm *.exe *.hi *.o
