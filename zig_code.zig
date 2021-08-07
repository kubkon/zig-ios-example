export fn zigFoo(bar: c_int) void
{
    _ = bar;
    // something
}

pub extern fn main(c_int, [*c]i8) c_int; // for when zig is main
