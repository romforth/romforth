#define ip	ix
#define w	hl
#define wl	l
#define tos	bc
#define tosl	c

cold:
	ld sp, #0xffff
	ld ip, #rom
	ld w, #cold

#if USEDICT
#include "prims_dict.s"
#else
#include "prims.s"
#endif

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
