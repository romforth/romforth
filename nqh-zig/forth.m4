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

const ns = 10;			// number of stacks
const ds = 8;			// depth of the each stack
var sp: usize = 0;		// the current stack which is in use
var d: [ds]usize = undefined;	// set of stack pointers (indexed by sp)
var datastack: [ns][ds]isize = undefined;	// set of stacks

fn dup() void {
    datastack[sp][d[sp]] = tos;
    d[sp] += 1;
}

fn lit(x: rom.Prims) isize {
    dup();
    return @intFromEnum(x);
}

fn call(_: rom.Prims) void {}
fn jmp(_: rom.Prims) void {}
fn br0(_: rom.Prims) void {}
fn br1(_: rom.Prims) void {}

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
