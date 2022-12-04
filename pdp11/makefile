test.out : forth.lda simh.cmds
	pdp11 simh.cmds
forth.lda : forth
	bin2load -a -f forth -o forth.lda
forth : forth.o forth.lds
	pdp11-aout-ld -T forth.lds forth.o -o forth
forth.o : forth.S rom.s
	pdp11-aout-as -mkd11d -al=forth.lst -o forth.o forth.S
rom.s : ../rom.4th ../fpp fpp.config prims.s genrom
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map > rom.s
	test -s rom.s
fpp.config : stepfile fpp.config.pdp11
	cat stepfile fpp.config.pdp11 > fpp.config
prims.s : prims.S
prims.S : genprims code.prims
	cat code.prims | ./genprims dict.map > prims.S
clean :
	rm -f forth.o forth forth.lda test.out forth.lst rom.s rom.map fpp.config prims.S prims.s dict.map
