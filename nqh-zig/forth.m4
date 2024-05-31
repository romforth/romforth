// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const std = @import("std");
const rom = @import("rom.zig");

var ip: usize = @sizeOf(@TypeOf(rom.func));
var b: rom.Bytecode = undefined;
var i: rom.Nqhcode = undefined;
var tos: isize = undefined;
var nos: isize = undefined;

const ns = 10;			// number of data stacks
const ds = 8;			// depth of each data stack
var sp: usize = 0;		// the current data stack which is in use
var d: [ds]usize = undefined;	// set of data stack pointers (indexed by sp)
var datastack: [ns][ds]isize = undefined;	// set of data stacks

const nr = 10;			// number of return stacks
const rs = 8;			// depth of each return stack
var rp: usize = 0;		// the current return stack which is in use
var r: [rs]usize = undefined;	// set of return stack pointers (indexed by rp)
var retstack: [nr][rs]usize = undefined;	// set of return stacks

const Memory = [256]u8;
var mem: Memory = undefined;

const Mix = packed union { i: isize, p: *Memory };

var varalias = [_]Mix{
    Mix{ .p = &mem },	// here is at index 0, hardcoded in genrom for now
    Mix{ .i = 1 },	// state is at index 1, hardcoded in genrom for now
};

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

fn call(x: rom.Prims) void {
    retstack[rp][r[rp]] = @intCast(ip);
    r[rp] += 1;
    ip = rom.fp[@intFromEnum(x)];
}

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

fn decode(op: rom.Opcode) !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    // try stdout.print("op: {}\n", .{op});
    switch (op) {
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

pub fn main() !void {
    while (true) {
        b = rom.bytes[ip];
        i = b.nqh;
        ip += 1;
        try decode(i.op);
    }
}
