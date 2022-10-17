	bits	16	; x86 real mode
	org	0x100	; x86 BIOS origin is 0x100 - must match in emulate.c

halt:
	hlt
