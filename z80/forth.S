#define ip	ix
#define w	hl
#define wl	l

cold:
	ld ip, #rom
	ld w, #cold
	ld wl, (ip)
	inc ip
	jp (w)

hlt:
	halt

rom:
	.db hlt-cold
