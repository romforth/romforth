all : x86/all
	(cd x86-as ; make)
	(cd pdp11 ; make)

allsteps :
	for i in $$(seq 0 4) 4.1 4.2 4.3 $$(seq 5 9) 10.1 10.2 10.3 $$(seq 11 38); do (echo "step=$$i" ; cat fpp.config.x86 ) > fpp.config ; (echo "step=$$i" ; cat pdp11/fpp.config.pdp11 ) > pdp11/fpp.config ; rm -f pdp11/test.out ; echo ; echo Step $$i ; $(MAKE) || break ; done

include x86/makefile

clean : x86/clean
	(cd x86-as ; make clean)
	(cd pdp11 ; make clean)
	rm -f fpp.config
