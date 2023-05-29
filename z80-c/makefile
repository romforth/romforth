forth.ihx : forth.c
	sdcc -mz80 forth.c
	cat cmds.ucsim | ucsim_z80 forth.ihx > test.log
	grep 'DE= 0x0000 \[DE\]= c3 195 \.' test.log > /dev/null
clean :
	bash -c "rm -f forth.{asm,ihx,lk,lst,map,noi,rel,sym} test.log"
