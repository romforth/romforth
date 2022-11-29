# forth.S : bootloader over serial port, initialization and inner interpreter
#
# Copyright (c) 2022 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

	.code16		# x86 real mode
	.text		# used to mark start location via the linker script

load:				# A small bootloader
	mov $ram, %di		# destination starts at ram
	mov $(mem-ram), %cx	# setup number of bytes to load
	mov $0x3f8, %dx		# from x86 serial port #1
	cld		# to auto increment register di after each byte is read
	rep insb	# load that number of bytes
ram:			# rest of the stuff can be loaded in via the serial port
	mov $load, %sp	# stack grows to low memory
	mov $rom, %si	# register SI is the equivalent of Forth's IP register
	mov $inner, %bp	# cache the label in register bp
restoredx:		# Initialize the default port to
	mov $0x3f8, %dx	# x86 serial port #1
restoreax:
	mov %bp, %ax	# initialize AH to this segment
inner:			# for use in the inner interpreter, since it is the only
	lodsb		# al=si++	# x86 register with read+auto increment
	jmp *%ax	# register AX is the equivalent of Forth's W register

#include "prims.s"

rom:

#include "rom.s"

#include "defs.s"

mem:
