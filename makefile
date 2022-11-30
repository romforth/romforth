all : x86/all
	(cd x86-as ; make)
	(cd pdp11 ; make)

allsteps :
	for i in $$(seq 0 37) ; do (echo "step=$$i" ; cat fpp.config.x86 ) > fpp.config ; echo ; echo Step $$i ; $(MAKE) || break ; done

include x86/makefile

clean : x86/clean
	(cd x86-as ; make clean)
	(cd pdp11 ; make clean)
	rm -f fpp.config
