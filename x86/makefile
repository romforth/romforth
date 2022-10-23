x86/all : x86/emulate x86/forth
	(dd if=x86/forth bs=1 skip=12 2>/dev/null ; cat test.inp) | x86/emulate x86/forth > x86/test.out
	cmp x86/test.out x86/test.expected
x86/forth : x86/forth.s x86/prims.s x86/rom.s x86/defs.s
	nasm -l x86/forth.lst x86/forth.s
x86/prims.s : x86/genprims x86/code.prims
	cat x86/code.prims | x86/genprims x86/dict.map > x86/prims.s
x86/defs.s : x86/genrom defs.4th x86/prims.s
	cat defs.4th | x86/genrom x86/defs.map x86/dict.map > x86/defs.s
x86/rom.s : x86/genrom x86/rom.4th x86/prims.s x86/defs.s
	cat x86/rom.4th | x86/genrom x86/rom.map x86/dict.map x86/defs.map > x86/rom.s
x86/clean :
	rm -f x86/forth x86/forth.lst x86/emulate x86/dict.map x86/prims.s x86/rom.s x86/test.out x86/defs.map x86/rom.map x86/defs.s
