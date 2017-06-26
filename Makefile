.PHONY: build forth forth.o

build: forth

forth.o:
	mkdir -p build
	nasm -g -f elf -o build/forth.o src/forth.asm

forth: forth.o word.o
	gcc -g -o build/forth build/forth.o build/word.o

word.o:
	mkdir -p build
	gcc -c -o build/word.o src/word.c

clean:
	rm -f build/forth build/forth.o
