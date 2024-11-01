all : forth.ihx
	echo run | ucsim_mos6502 -I if=rom'[0x7fff]' forth.ihx
forth.ihx : forth.S
	sdas6500 -l -o forth.S
	sdld -i forth.rel
clean:
	rm -f forth.ihx forth.lk forth.lst forth.map forth.noi forth.rel fpp.config
