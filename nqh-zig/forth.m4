// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const std = @import("std");
const rom = @import("rom.zig");

var ip: usize = 0;
var i: rom.Nqhcode = undefined;
var tos: u8 = undefined;

fn lit(_: rom.Prims) void {}
fn call(_: rom.Prims) void {}
fn jmp(_: rom.Prims) void {}
fn br0(_: rom.Prims) void {}
fn br1(_: rom.Prims) void {}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    out: while (true) {
        i = rom.bytes[ip];
        ip += 1;
        switch (i.op) {
            .lit1 => lit(i.value),
            .lit2 => lit(i.value),
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
