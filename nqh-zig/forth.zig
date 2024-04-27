// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const std = @import("std");
const rom = @import("rom.zig");

var ip: usize = 0;
var i: rom.Bytecode = undefined;
var tos: i8 = undefined;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    out: while (true) {
        i = rom.bytes[ip];
        ip += 1;
        switch (i) {
            .bye => break :out,
            .emit => {
                try stdout.print("{c}", .{@as(u8, @intCast(tos))});
            },
            .key => {
                tos = 'f';
            },
        }
    }
}
