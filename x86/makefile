x86/all : x86/emulate x86/forth
	x86/emulate x86/forth
x86/forth : x86/forth.s
	nasm -l x86/forth.lst x86/forth.s
x86/clean :
	rm x86/forth x86/forth.lst x86/emulate
