#define ip	ix
#define w	hl
#define wl	l
#define tos	bc
#define tosl	c
#define tosh	b
#define nos	de
#define nosl	e
#define nosh	d
#define rp	iy

cold:
	ld sp, #0xffff
	ld ip, #rom
	ld w, #cold

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

spfs:
	ld rp, #0
	add rp, sp
	push rp
	push tos
	pop rp
	pop tos
	ld sp, rp
	jp inner
reallit:
	push tos
	ld tosl, (ip)
	inc ip
	ld tosh, (ip)
	inc ip
	jp inner
realj:
	ld a, (ip)
	inc ip
	ld e, a
	rlca
	sbc a, a
	ld d, a
	add ip, de
	jp inner
rom:

#include "rom.s"

#define USEDEFS 0
#define USEDICT 0

#if USEDEFS
#if USEDICT
#include "dict.s"
#include "defs_dict.s"
#else
#include "defs.s"
#endif
#endif

mem:	.ds 2048
