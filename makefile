all : x86/all
	(cd x86-as ; make)

include x86/makefile

clean : x86/clean
	(cd x86-as ; make clean)
