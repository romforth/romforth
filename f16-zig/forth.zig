// A Forth Virtual Machine implementing the F16 encoding
//
// Copyright (c) 2025 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

// See f16.txt for the documentation about the F16 "processor".

// As mentioned there, in case of a discrepancy between the documentation and
// the implementation, this implementation is "more" correct since it can be
// checked/verified.

const std = @import("std");

var ip: usize = 0;

const ns = 10;			// number of data stacks
const ds = 8;			// depth of each data stack
var sp: usize = 0;		// the current data stack which is in use
var d: [ds]usize = undefined;	// set of data stack pointers (indexed by sp)
var datastack: [ns][ds]isize = undefined;	// set of data stacks

var tos: u16 = undefined;
var nos: isize = undefined;

const Opcode = enum(u4) {
    Push,	// 0
    Pop,	// 1
    Mov,	// 2
    Xch,	// 3
    Inv,	// 4
    Neg,	// 5
    Add,	// 6
    Sub,	// 7
    And,	// 8
    Or,		// 9
    Xor,	// A
    Shl,	// B
    Shr,	// C
    Exec,	// D
    Call,	// E
    Enter,	// F
};

var b: Opcode = undefined;

const bytes = [_]Opcode{
    .Pop, .Neg, .Inv,		// lit4 4	[ 4		# aka: ^D
    .Pop, .Add, .Enter, .Enter,// lit8 0xff	[ 4 0xff	# port 0xff
    .Mov, .Pop,		// p!		[ # assume that IO[0xff]=^D:bye
};

fn dup() void {
    datastack[sp][d[sp]] = tos;
    d[sp] += 1;
}

fn nip() void {
    d[sp] -= 1;
    nos = datastack[sp][d[sp]];
}

fn decode(i: Opcode) !void {
    switch (i) {
        .Push => {},
        .Pop => {
            b = bytes[ip];
            ip += 1;
            switch (b) {
                .Push => {},
                .Pop => {},
                .Mov => {},
                .Xch => {},
                .Inv => {},
                .Neg => {		// lit4
                    b = bytes[ip];
                    ip += 1;
                    dup();
                    tos = @intFromEnum(b);
                    // const stdout = std.io.getStdOut().writer();
                    // try stdout.print("lit4 {d}\n", .{tos});
                },
                .Add => {		// lit8
                    b = bytes[ip];
                    ip += 1;
                    dup();
                    tos = @intFromEnum(b);
                    b = bytes[ip];
                    ip += 1;
                    tos <<= 4; // just use big endian - don't want to struggle
                    tos |= @intFromEnum(b); // too much with zig casts right now
                    // const stdout = std.io.getStdOut().writer();
                    // try stdout.print("lit8 {d}\n", .{tos});
                },
                .Sub => {},
                .And => {},
                .Or => {},
                .Xor => {},
                .Shl => {},
                .Shr => {},
                .Exec => {},
                .Call => {},
                .Enter => {},
            }
        },
        .Mov => {
            b = bytes[ip];
            ip += 1;
            switch (b) {
                .Push => {},
                .Pop => {		// p! but special cased to handle bye
                    nip();
                    if (tos == 0xFF and nos == 0x4) {
                        std.process.exit(0);
                    } else { 		// p!
                    }
                },
                .Mov => {},
                .Xch => {},
                .Inv => {},
                .Neg => {},
                .Add => {},
                .Sub => {},
                .And => {},
                .Or => {},
                .Xor => {},
                .Shl => {},
                .Shr => {},
                .Exec => {},
                .Call => {},
                .Enter => {},
            }
        },
        .Xch => {},
        .Inv => {},
        .Neg => {},
        .Add => {},
        .Sub => {},
        .And => {},
        .Or => {},
        .Xor => {},
        .Shl => {},
        .Shr => {},
        .Exec => {},
        .Call => {},
        .Enter => {},
    }
}
pub fn main() !void {
    while (true) {
        b = bytes[ip];
        ip += 1;
        try decode(b);
    }
}
