all : ../x86/emulate forth
	(dd if=forth bs=1 skip=12 2>/dev/null) | ../x86/emulate forth
forth : forth.o forth.lds
	ld -o forth -T forth.lds forth.o
forth.o : prims.s rom.s
prims.s : genprims code.prims
	cat code.prims | ./genprims dict.map > prims.s
rom.s : genrom rom.4th prims.s
	cat rom.4th | ./genrom rom.map dict.map > rom.s
clean :
	rm -f forth.o forth prims.s dict.map rom.s rom.map
