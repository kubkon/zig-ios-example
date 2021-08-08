const std = @import("std");
const log = std.log.scoped(.app);

extern "c" fn appMain(c_int, *const ?*u8) c_int;

pub fn main() !void {
    log.warn("spinning up Objective-C main", .{});
    const args: ?*u8 = null;
    const code = appMain(0, &args);
    log.warn("cleaning up; exit code {d}", .{code});
}
