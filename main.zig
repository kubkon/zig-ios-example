const std = @import("std");

extern "c" fn appMain() isize;

export fn dummyMsg() [*:0]const u8 {
    return "Hello from Zig!";
}

pub fn main() void {
    _ = appMain();
}
