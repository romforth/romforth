	bits	16	; x86 real mode
	org	0x100	; x86 BIOS origin is 0x100 - must match in emulate.c

%macro next 0
	jmp bp
%endmacro

	mov si, rom	; register SI is the equivalent of Forth's IP register
	mov bp, inner	; cache the label in register bp
restoredx:		; Initialize the default port to
	mov dx, 0x3f8	; x86 serial port #1
restoreax:
	mov ax, $	; initialize AH to this segment
inner:			; for use in the inner interpreter, since it is the only
	lodsb		; al=si++	# x86 register with read+auto increment
	jmp ax		; register AX is the equivalent of Forth's W register

%include "x86/prims.s"

rom:

%include "x86/rom.s"
