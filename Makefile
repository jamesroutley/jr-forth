.PHONY: clean

build: clean forth

forth: clean forth.o word.o find.o
	gcc -g -o build/forth build/forth.o build/word.o

forth.o: clean
	mkdir -p build
	nasm -g -f elf -o build/forth.o src/forth.asm

find.o: clean
	mkdir -p build
	gcc -c -o build/find.o src/find.c

word.o: clean
	mkdir -p build
	gcc -c -o build/word.o src/word.c

clean:
	rm -f build/forth build/forth.o
	rm -f build/find build/find.o
	rm -f build/word build/word.o
