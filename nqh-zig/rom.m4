// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

// rom.m4 : "not quite Huffman" encoding and ROM layout
// See JOURNAL entry dated 26 Apr '24 for opcode details

pub const Opcode = enum(u3) {
    lit1,
    lit2,
    call1,
    call2,
    jmp,
    br0,
    br1,
    prims,
};

pub const Prims = enum(u5) {
include(`prims.m4')
};

pub const Nqhcode = packed struct {
    // As per the docs bits are packed from left to right in the order declared
    value: Prims,
    op: Opcode,
    // so the byte layout is: | op:3 | value:5 |, I think
};


pub const Bytecode = packed union {
	byte: i8,
	nqh: Nqhcode,
};

pub const bytes = [_]Bytecode{
include(`rom_zig.m4')
};
