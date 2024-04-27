pub const Bytecode = enum(u8) {
    emit,
    key,
    bye,
};

pub const bytes = [_]Bytecode{
	.key,
	.emit,
	.bye,
};
