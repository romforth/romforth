all : ../x86/emulate forth ../x86/test.exp ../test.inp ../fpp ../fpp.config
	(dd if=forth bs=1 skip=12 2>/dev/null; cat ../test.inp | ../fpp -DTESTROM -c ../fpp.config | perl -pe chomp) | ../x86/emulate forth > test.out
	cmp test.out ../x86/test.exp
forth : forth.o forth.lds
	ld -o forth -T forth.lds forth.o
forth.o : prims.s rom.s defs.s
prims.s : genprims code.prims
	cat code.prims | ./genprims dict.map > prims.s
defs.s : genrom ../defs.4th prims.s ../fpp ../fpp.config
	cat ../defs.4th | ../fpp -DTESTROM -c ../fpp.config | ./genrom defs.map dict.map > defs.s
rom.s : genrom ../rom.4th prims.s defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c ../fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth.o forth prims.s dict.map rom.s rom.map test.out defs.s defs.map
