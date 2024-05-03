// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const std = @import("std");
const rom = @import("rom.zig");

var ip: usize = 0;
var i: rom.Nqhcode = undefined;
var tos: isize = undefined;
var nos: isize = undefined;

const ns = 10;			// number of stacks
const ds = 8;			// depth of the each stack
var sp: usize = 0;		// the current stack which is in use
var d: [ds]usize = undefined;	// set of stack pointers (indexed by sp)
var datastack: [ns][ds]isize = undefined;	// set of stacks

fn dup() void {
    datastack[sp][d[sp]] = tos;
    d[sp] += 1;
}

fn drop() void {
    d[sp] -= 1;
    tos = datastack[sp][d[sp]];
}

fn dip() void {
    datastack[sp][d[sp]] = nos;
    d[sp] += 1;
}

fn nip() void {
    d[sp] -= 1;
    nos = datastack[sp][d[sp]];
}

fn lit(x: rom.Prims) isize {
    dup();
    return @intFromEnum(x);
}

fn call(_: rom.Prims) void {}

fn jmp(o: rom.Prims) void {
    var ofs: u5 = @intFromEnum(o);
    if (ofs > 15) {
        ip -= (ofs-15);
    } else {
        if (ofs == 0) {
            // treat this as a lit3 which can handle 32 bits
            dup();
            tos = 0;
            comptime var k = 0;
            inline while (k < 4) : (k += 1) {
                tos |= @as(isize, rom.bytes[ip].byte) << k*8;
                ip += 1;
            }
        } else {
            ip += ofs;
        }
    }
}

fn br0(o: rom.Prims) void {
    var ofs: u5 = @intFromEnum(o);
    if (tos==0) {
        if (ofs > 15) {
            ip -= (ofs-15);
        } else {
            ip += ofs;
        }
    }
    drop();
}

fn br1(o: rom.Prims) void {
    var ofs: u5 = @intFromEnum(o);
    if (tos!=0) {
        if (ofs > 15) {
            ip -= (ofs-15);
        } else {
            ip += ofs;
        }
    }
    drop();
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    out: while (true) {
        i = rom.bytes[ip].nqh;
        ip += 1;
        switch (i.op) {
            .lit1 => tos = lit(i.value),
            .lit2 => {
                tos = lit(i.value) | @as(isize, rom.bytes[ip].byte) << 5;
                if (tos & (1<<12) == (1<<12)) {
                    tos = tos&(-1^(1<<12));
                    tos = -tos;
                }
                ip += 1;
            },
            .call1 => call(i.value),
            .call2 => call(i.value),
            .jmp => jmp(i.value),
            .br0 => br0(i.value),
            .br1 => br1(i.value),
            .prims => switch (i.value) {
include(`forth_zig.m4')
            },
        }
    }
}
