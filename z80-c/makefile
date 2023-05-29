forth.ihx : forth.c
	sdcc -mz80 forth.c
	cat cmds.ucsim | ucsim_z80 forth.ihx
clean :
	bash -c "rm -f forth.{asm,ihx,lk,lst,map,noi,rel,sym}"
