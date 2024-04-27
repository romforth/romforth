// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const rom = @import("rom.zig");

var ip: usize = 0;
var i: rom.Bytecode = undefined;

pub fn main() !void {
    out: while (true) {
        i = rom.bytes[ip];
        ip += 1;
        switch (i) {
            .bye => break :out,
        }
    }
}
