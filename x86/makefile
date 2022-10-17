x86/all : x86/emulate x86/forth
	x86/emulate x86/forth
x86/forth : x86/forth.s x86/prims.s
	nasm -l x86/forth.lst x86/forth.s
x86/prims.s : x86/code.prims
	cat x86/code.prims | x86/genprims x86/dict.map > x86/prims.s
x86/clean :
	rm -f x86/forth x86/forth.lst x86/emulate x86/dict.map x86/prims.s
