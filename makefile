all :
	(cd x86 ; make)
	(cd x86-as ; make)
	(cd pdp11 ; make)
	(cd C ; make)
	(cd x86-user ; make)
	(cd x86-sys ; make)
	(cd x86-32 ; make)
	(cd m68k ; make)
	(cd sparc ; make)
	(cd z80 ; make)
	(cd z80-c ; make)
	(cd z180-sdcc ; make)
	(cd z80n-sdcc ; make)
	(cd msp430-as ; make)
	(cd arm-zigcc ; make)
	(cd arm64-sys ; make)
	(cd riscv-zigcc ; make)

allsteps :
	./runallsteps

size : all
	./gensize
clean :
	(cd x86 ; make clean)
	(cd x86-as ; make clean)
	(cd pdp11 ; make clean)
	(cd C ; make clean)
	(cd x86-user ; make clean)
	(cd x86-sys ; make clean)
	(cd x86-32 ; make clean)
	(cd m68k ; make clean)
	(cd sparc ; make clean)
	(cd z80 ; make clean)
	(cd z80-c ; make clean)
	(cd z180-sdcc ; make clean)
	(cd z80n-sdcc ; make clean)
	(cd msp430-as ; make clean)
	(cd arm-zigcc ; make clean)
	(cd arm64-sys ; make clean)
	(cd riscv-zigcc ; make clean)
