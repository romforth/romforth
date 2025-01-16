// A Forth Virtual Machine implementing the F16 encoding
//
// Copyright (c) 2025 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

// See f16.txt for the documentation about the F16 "processor".

// As mentioned there, in case of a discrepancy between the documentation and
// the implementation, this implementation is "more" correct since it can be
// checked/verified.

const debug = 0;

const std = @import("std");
const rom = @import("rom.zig");

var ip: usize = 0;

const ns = 10;			// number of data stacks
const ds = 8;			// depth of each data stack
var sp: usize = 0;		// the current data stack which is in use
var d: [ds]usize = undefined;	// set of data stack pointers (indexed by sp)
var datastack: [ns][ds]i16 = undefined;	// set of data stacks

var tos: i16 = undefined;
var nos: isize = undefined;

var b: rom.Opcode = undefined;

fn dup() void {
    datastack[sp][d[sp]] = tos;
    d[sp] += 1;
}

fn drop() void {
    d[sp] -= 1;
    tos = datastack[sp][d[sp]];
}

fn nip() void {
    d[sp] -= 1;
    nos = datastack[sp][d[sp]];
}

fn decode(i: rom.Opcode) !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    switch (i) {
        .Push => {
            b = rom.bytes[ip];
            ip += 1;
            switch (b) {
                .Push => { dup(); },
                .Pop => {},
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
        .Pop => {
            b = rom.bytes[ip];
            ip += 1;
            switch (b) {
                .Push => { drop(); },
                .Pop => {},
                .Mov => {},
                .Xch => {},
                .Inv => {},
                .Neg => {		// lit4
                    b = rom.bytes[ip];
                    ip += 1;
                    dup();
                    tos = @intFromEnum(b);
                    if (debug == 1) { try stdout.print("lit4 {d}\n", .{tos}); }
                },
                .Add => {		// lit8
                    b = rom.bytes[ip];
                    ip += 1;
                    dup();
                    tos = @intFromEnum(b);
                    b = rom.bytes[ip];
                    ip += 1;
                    tos <<= 4; // just use big endian - don't want to struggle
                    tos |= @intFromEnum(b); // too much with zig casts right now
                    if (debug == 1) { try stdout.print("lit8 {d}\n", .{tos}); }
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
            b = rom.bytes[ip];
            ip += 1;
            switch (b) {
                .Push => {},
                .Pop => {},
                .Mov => {},
                .Xch => {},
                .Inv => {
                    if (tos == 0) {	// p@, tos==0 implies key
                        tos = try stdin.readByte();
                        if (debug == 1) {
                            try stdout.print("key : got {d}\n", .{tos});
                        }
                    } else {		// ignore, no other ports are supported
                    }
                },
                .Neg => {		// p! but special cased to handle bye
                    nip();
                    if (debug == 1) {
                        try stdout.print("nip : got {d}\n", .{nos});
                    }
                    if (tos == 0xFF and nos == 0x4) {
                        std.process.exit(0);
                    } else { 		// p!
                        if (tos == 1) {	// emit
                            var c: u8 = @truncate(@as(usize,@intCast(nos)));
                            try stdout.print("{c}", .{c});
                            drop();
                        } else {	// ignore, no other ports are supported
                        }
                    }
                },
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
        b = rom.bytes[ip];
        ip += 1;
        try decode(b);
    }
}
