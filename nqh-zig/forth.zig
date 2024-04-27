// A Forth Virtual Machine implementing the "not quite Huffman" encoding
//
// Copyright (c) 2024 Charles Suresh <romforth@proton.me>
// SPDX-License-Identifier: AGPL-3.0-only
// Please see the LICENSE file for the Affero GPL 3.0 license details

const Bytecode = enum(u8) {
    bye,
};

const rom = [_]Bytecode{
    .bye,
};

var ip: usize = 0;
var i: Bytecode = undefined;

pub fn main() !void {
    out: while (true) {
        i = rom[ip];
        ip += 1;
        switch (i) {
            .bye => break :out,
        }
    }
}
