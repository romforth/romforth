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

realcall:			; tos:A   ip:X  [ B
	push tos		; tos:A   ip:X  [ B A
	push ip			; tos:A   ip:X  [ B A X
	pop tos			; tos:X   ip:X  [ B A
	ld (rp), tosl		; tos:X   ip:X  [ B A | X.l ]
	inc rp
	ld (rp), tosh		; tos:X   ip:X  [ B A | X ]
	inc rp
	pop ip			; tos:X   ip:A  [ B   | X ]
	pop tos			; tos:B	  ip:A  [     | X ]
	jp inner
realenter:			; tos:A   ip:X   *ip=B.C [
	push tos		; tos:A   ip:X   *ip=B.C [ A
	ld tosl, (ip)		; tos:B   ip:X   *ip=B.C [ A
	inc ip			; tos:B   ip:X+1 *ip=C   [ A
	ld tosh, (ip)		; tos:B.C ip:X+1 *ip=C   [ A
	inc ip			; tos:B.C ip:X+2 *ip=?   [ A
	push tos		; tos:B.C ip:X+2 *ip=?   [ A B.C
	ex (sp), ip		; tos:B.C ip:B.C *ip=??  [ A X+2
	pop tos			; tos:X+2 ip:B.C *ip=??  [ A
	jr tor			; tos:A   ip:B.C *ip=??  [   | X+2 ]

realexit:			; tos:A   ip:?           [   | X+2 ]
	push tos		; tos:A   ip:?           [ A | X+2 ]
	dec rp			; tos:A   ip:?           [ A | X+2 ]
	ld tosh, (rp)		; tos:?   ip:?           [ A | X+2 ]
	dec rp			; tos:?   ip:?           [ A |     ]
	ld tosl, (rp)		; tos:X+2 ip:?           [ A |     ]
	push tos		; tos:X+2 ip:?           [ A X+2
	pop ip			; tos:X+2 ip:X+2         [ A
	pop tos			; tos:A   ip:X+2         [
	jp inner
tor:
	ld (rp), tosl
	inc rp
	ld (rp), tosh
	inc rp
	pop tos
	jp inner
fromr:
	push tos
	dec rp
	ld tosh, (rp)
	dec rp
	ld tosl, (rp)
	jp inner
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
