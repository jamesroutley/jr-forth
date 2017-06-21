.PHONY: build 

build:
	mkdir -p build
	nasm -g -f elf src/forth.asm -o build/forth.o
	gcc -g build/forth.o -o build/forth

clean:
	rm -f build/forth build/forth.o
