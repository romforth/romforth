all : ../x86/emulate forth
	(dd if=forth bs=1 skip=12 2>/dev/null) | ../x86/emulate forth
forth : forth.o forth.lds
	ld -o forth -T forth.lds forth.o
clean :
	rm -f forth.o forth
