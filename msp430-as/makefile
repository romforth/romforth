all : forth
	./run_mspdebug
forth : forth.o
	msp430-unknown-elf-ld -o forth forth.o
forth.o : forth.s
	msp430-unknown-elf-as -o forth.o -al=forth.lst forth.s
clean :
	rm -f forth forth.lst forth.o test.inp test.out fpp.config forth.s
