do: count.exe
	./count.exe < ~/Dropbox/tw/hand12.txt

count.exe: count.hs
	ghc -O3 $^ -o $@

clean:
	rm *.exe *.hi *.o
