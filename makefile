all :
	(cd x86 ; make)
	(cd x86-as ; make)
	(cd pdp11 ; make)
	(cd C ; make)

allsteps :
	./runallsteps

size : all
	./gensize
clean :
	(cd x86 ; make clean)
	(cd x86-as ; make clean)
	(cd pdp11 ; make clean)
	(cd C ; make clean)
