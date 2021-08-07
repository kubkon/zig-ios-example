const std = @import("std");
const Allocator = std.mem.Allocator;
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable("app", null);
    b.default_step.dependOn(&exe.step);
    exe.addCSourceFile("main.m", &[0][]const u8{});
    exe.addPackagePath("zigCode", "zig_code.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.linkLibC();
    exe.linkFramework("Foundation");
    exe.linkFramework("UIKit");

    if (!std.Target.current.isDarwin()) {
        exe.addSystemIncludeDir("/usr/include");
        exe.addLibPath("/usr/lib");
        exe.addFrameworkDir("/System/Library/Frameworks");
    }

    exe.install();

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}/bin/app", .{b.install_path});
    defer b.allocator.free(install_path);
    b.installFile(install_path, "bin/MadeWithZig.app/app");
    b.installFile("Info.plist", "bin/MadeWithZig.app/Info.plist");
}
