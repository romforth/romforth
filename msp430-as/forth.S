#define ip	R4

	.cpu 430
start :
	mov #rom, ip
	br @ip+
halt :
	nop
rom:
	.word halt
