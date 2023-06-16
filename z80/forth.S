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

rpfs:
	push tos
	ex (sp), rp
	pop tos
	jp inner
cfetch:
	ld (rpsave), rp
	push tos
	pop rp
	ld tosl, (rp)
	xor a, a
	ld tosh, a
	ld rp, (rpsave)
	jp inner
cstore:
	ld (rpsave), rp
	pop nos
	push tos
	pop rp
	ld (rp), nosl
	ld rp, (rpsave)
	jp inner
mfetch:
	ld tosl, (rp)
	inc rp
	ld tosh, (rp)
	ld rp, (rpsave)
	jp inner
mstore:
	ld (rp), nosl
	inc rp
	ld (rp), nosh
	pop tos
	ld rp, (rpsave)
	jp inner
spfs:
	ld (rpsave), rp
	ld rp, #0
	add rp, sp
	push rp
	push tos
	pop rp
	pop tos
	ld sp, rp
	ld rp, (rpsave)
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

rpsave: .ds 2
mem:	.ds 2048
