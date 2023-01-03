threeforth : test.dict
twoforth : test.out
oneforth : test.out
test.dict : ../x86/emulate forth_dict ../x86/test.exp ../test.inp ../fpp ../x86/fpp.config
	(dd if=forth_dict bs=1 skip=12 2>/dev/null; cat ../test.inp | ../fpp -DTESTROM -c ../x86/fpp.config | perl -pe chomp) | ../x86/emulate forth_dict > test.dict
	cmp test.dict ../x86/test.exp
test.out : ../x86/emulate forth ../x86/test.exp ../test.inp ../fpp ../x86/fpp.config
	(dd if=forth bs=1 skip=12 2>/dev/null; cat ../test.inp | ../fpp -DTESTROM -c ../x86/fpp.config | perl -pe chomp) | ../x86/emulate forth > test.out
	cmp test.out ../x86/test.exp
forth : forth.o forth.lds
	ld -o forth -T forth.lds forth.o
forth_dict : forth_dict.o forth.lds
	ld -o forth_dict -T forth.lds forth_dict.o
forth.o : prims.s rom.s defs.s
forth_dict.o : prims_dict.s rom.s defs_dict.s
forth_dict.S : forth.S prims_dict.s
	cp forth.S forth_dict.S
	sed -i 's/include \"prims/include \"prims_dict/' forth_dict.S
	sed -i 's/include \"defs/include \"defs_dict/' forth_dict.S
prims.s : genprims code.prims ../fpp ../x86/fpp.config
	cat code.prims | ../fpp -DTESTROM -c ../x86/fpp.config | ./genprims dict.map > prims.s
prims_dict.s : genprims code.prims prims.s ../fpp ../x86/fpp.config
	cat code.prims | ../fpp -DTESTROM -c ../x86/fpp.config | ./genprims -d dict.map > prims_dict.s
defs.s : genrom ../defs.4th prims.s ../fpp ../x86/fpp.config
	cat ../defs.4th | ../fpp -DTESTROM -c ../x86/fpp.config | ./genrom defs.map dict.map > defs.s
defs_dict.s : genrom ../defs.4th prims_dict.s ../fpp ../x86/fpp.config
	cat ../defs.4th | ../fpp -DTESTROM -c ../x86/fpp.config | ./genrom -d defs.map dict.map > defs_dict.s
rom.s : genrom ../rom.4th prims.s defs.s
	cat ../rom.4th | ../fpp -DTESTROM -c ../x86/fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth.o forth prims.s dict.map rom.s rom.map test.out defs.s defs.map forth_dict forth_dict.o forth_dict.S defs_dict.s dict.s latest.s prims_dict.s test.dict
