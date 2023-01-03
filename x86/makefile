threeforth : test.dict
twoforth : test.out
oneforth : test.out
test.dict : emulate forth_dict test.exp ../test.inp ../fpp fpp.config
	(dd if=forth_dict bs=1 skip=12 2>/dev/null ; cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp) | ./emulate forth_dict > test.dict
	cmp test.dict test.exp
test.out : emulate forth test.exp ../test.inp ../fpp fpp.config
	(dd if=forth bs=1 skip=12 2>/dev/null ; cat ../test.inp | ../fpp -DTESTROM -c fpp.config | perl -pe chomp) | ./emulate forth > test.out
	cmp test.out test.exp
test.exp : ../test.expected fpp.config ../fpp
	cat ../test.expected | ../fpp -DTESTROM -c fpp.config | perl -pe chomp > test.exp
fpp.config : fpp.config.x86 ../pdp11/stepfile
	cat ../pdp11/stepfile fpp.config.x86 > fpp.config
forth : forth.s prims.s rom.s defs.s
	nasm -DTESTROM -l forth.lst forth.s
forth_dict : forth_dict.s prims_dict.s rom.s defs_dict.s
	nasm -DTESTROM -l forth_dict.lst forth_dict.s
forth_dict.s : forth.s
	cp forth.s forth_dict.s
	sed -i 's/include \"prims/include \"prims_dict/' forth_dict.s
	sed -i 's/include \"defs/include \"defs_dict/' forth_dict.s
prims.s : genprims code.prims ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims dict.map > prims.s
prims_dict.s : genprims code.prims prims.s ../fpp fpp.config
	cat code.prims | ../fpp -DTESTROM -c fpp.config | ./genprims -d dict.map > prims_dict.s
defs.s : genrom ../defs.4th prims.s ../fpp fpp.config
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom defs.map dict.map > defs.s
defs_dict.s : genrom ../defs.4th prims_dict.s ../fpp fpp.config
	cat ../defs.4th | ../fpp -DTESTROM -c fpp.config | ./genrom -d defs.map dict.map > defs_dict.s
rom.s : genrom ../rom.4th prims.s defs.s ../fpp fpp.config
	cat ../rom.4th | ../fpp -DTESTROM -c fpp.config | ./genrom rom.map dict.map defs.map > rom.s
clean :
	rm -f forth forth.lst emulate dict.map prims.s rom.s test.out defs.map rom.map defs.s defs.notest.s rom.notest.s forth.notest forth.notest.lst test.exp prims_dict.s defs_dict.s dict.s forth_dict forth_dict.lst forth_dict.s latest.s fpp.config test.dict
notest : emulate forth.notest ../test.inp
	(dd if=forth.notest bs=1 skip=12 2>/dev/null ; cat ../test.inp) | ./emulate forth.notest
forth.notest : forth.s prims.s rom.notest.s defs.notest.s
	nasm -o forth.notest -l forth.notest.lst forth.s
defs.notest.s : genrom ../defs.4th prims.s ../fpp fpp.config
	cat ../defs.4th | ../fpp -c fpp.config | ./genrom defs.map dict.map > defs.notest.s
rom.notest.s : genrom ../rom.4th prims.s defs.notest.s ../fpp fpp.config
	cat ../rom.4th | ../fpp -c fpp.config | ./genrom rom.map dict.map defs.map > rom.notest.s
