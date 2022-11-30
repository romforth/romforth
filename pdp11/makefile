sim : forth.lda simh.cmds
	pdp11 simh.cmds
	touch sim
forth.lda : forth
	bin2load -a -f forth -o forth.lda
forth : forth.o forth.lds
	pdp11-aout-ld -T forth.lds forth.o -o forth
forth.o : forth.S
	pdp11-aout-as -o forth.o forth.S
clean :
	rm -f forth.o forth forth.lda sim
