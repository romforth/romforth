x86/all : x86/emulate x86/forth
	cat test.inp | x86/emulate x86/forth
x86/forth : x86/forth.s x86/prims.s x86/rom.s
	nasm -l x86/forth.lst x86/forth.s
x86/prims.s : x86/genprims x86/code.prims
	cat x86/code.prims | x86/genprims x86/dict.map > x86/prims.s
x86/rom.s : x86/genrom x86/rom.4th x86/prims.s
	cat x86/rom.4th | x86/genrom x86/dict.map > x86/rom.s
x86/clean :
	rm -f x86/forth x86/forth.lst x86/emulate x86/dict.map x86/prims.s x86/rom.s
