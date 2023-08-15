	.globl _start
_start:
	adrp x0, rom
	add x0, x0, #rom
	adrp x1, next
	add x1, x1, #next
next:
	ldrb w2, [x0]
	add x2, x2, x1
	br x2
bye:
	mov x0, #0
	mov w8, #93
	svc #0
rom:
	.byte bye-next
