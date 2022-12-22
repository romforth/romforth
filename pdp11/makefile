threeforth : test.dict prims_dict.S defs_dict.s
test.dict : forth_dict.lda simh_dict.cmds test.inp test.exp test.out
	rm -f test.dict
	pdp11 simh_dict.cmds | grep 'HALT instruction, PC: 000420'
	cmp test.dict test.exp
simh_dict.cmds : simh.cmds
	cp simh.cmds simh_dict.cmds
	sed -i 's/forth/forth_dict/' simh_dict.cmds
	sed -i 's/test\.out/test\.dict/' simh_dict.cmds
	sed -i 's/forth\.lda/forth_dict\.lda/' simh_dict.cmds
twoforth : test.out
oneforth : test.out
test.out : forth.lda simh.cmds test.inp test.exp
	rm -f test.out
	pdp11 simh.cmds | grep 'HALT instruction, PC: 000420'
	cmp test.out test.exp
test.inp : ../test.inp ../fpp fpp.config geninp
	cat ../test.inp | ../fpp -DTESTROM -c fpp.config | ./geninp > test.inp
test.exp : ../test.expected ../fpp fpp.config
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
forth.lda : forth
	bin2load -a -f forth -o forth.lda
forth_dict.lda : forth_dict
	bin2load -a -f forth_dict -o forth_dict.lda
forth : forth.o forth.lds
	pdp11-aout-ld -T forth.lds forth.o -o forth
forth_dict : forth_dict.o forth.lds
	pdp11-aout-ld -T forth.lds forth_dict.o -o forth_dict
forth.o : forth.S rom.s defs.s
	pdp11-aout-as -al=forth.lst -o forth.o forth.S
forth_dict.o : forth_dict.S rom.s defs_dict.s
	pdp11-aout-as -al=forth_dict.lst -o forth_dict.o forth_dict.S
forth_dict.S : forth.S
	cp forth.S forth_dict.S
	sed -i 's/include \"prims/include \"prims_dict/' forth_dict.S
	sed -i 's/include \"defs/include \"defs_dict/' forth_dict.S
rom.s : ../rom.4th ../fpp fpp.config prims.s defs.s genrom
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map > rom.s
	test -s rom.s
fpp.config : stepfile fpp.config.pdp11
	cat stepfile fpp.config.pdp11 > fpp.config
prims.s : prims.S
prims_dict.s : prims_dict.S
prims.S : genprims code.prims
	cat code.prims | grep -v "var latest" | ./genprims dict.map > prims.S
prims_dict.S : genprims code.prims
	cat code.prims | ./genprims -d dict.map > prims_dict.S
defs.s : ../defs.4th ../fpp fpp.config prims.s genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom defs.map dict.map > defs.s
defs_dict.s : ../defs.4th ../fpp fpp.config prims_dict.s genrom
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -d defs.map dict.map > defs_dict.s
clean :
	rm -f forth.o forth forth.lda test.out forth.lst rom.s rom.map fpp.config prims.S prims.s dict.map test.inp test.exp defs.s defs.map sim forth_dict.S forth_dict forth_dict.lda forth_dict.lst forth_dict.o defs_dict.s dict.s latest.s prims_dict.S prims_dict.s simh_dict.cmds test.dict
