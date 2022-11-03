all : ../x86/emulate forth
	(dd if=forth bs=1 skip=12 2>/dev/null; cat ../test.inp) | ../x86/emulate forth > test.out
	cmp test.out test.expected
forth : forth.o forth.lds
	ld -o forth -T forth.lds forth.o
forth.o : prims.s rom.s defs.s
prims.s : genprims code.prims
	cat code.prims | ./genprims dict.map > prims.s
defs.s : genrom defs.4th prims.s
	cat defs.4th | ./genrom defs.map dict.map > defs.s
rom.s : genrom rom.4th prims.s defs.s
	cat rom.4th | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth.o forth prims.s dict.map rom.s rom.map test.out defs.s defs.map
