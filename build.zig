const std = @import("std");
const Allocator = std.mem.Allocator;
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{
        .whitelist = &[_]std.zig.CrossTarget{
            .{ .cpu_arch = .aarch64, .os_tag = .ios },
            .{ .cpu_arch = .aarch64, .os_tag = .ios, .abi = .simulator },
            .{ .cpu_arch = .x86_64, .os_tag = .ios, .abi = .simulator },
        },
    });

    if (b.sysroot == null) {
        std.log.warn("You haven't set the path to Apple SDK which may lead to build errors.", .{});
        std.log.warn("Hint: you can the path to Apple SDK with --sysroot <path> flag like so:", .{});
        std.log.warn("  zig build --sysroot $(xcrun --sdk iphoneos --show-sdk-path) -Dtarget=aarch64-ios", .{});
    }

    const exe = b.addExecutable("app", "main.zig");
    b.default_step.dependOn(&exe.step);
    exe.addIncludeDir(".");
    exe.addCSourceFiles(&[_][]const u8{ "AppMain.m", "AppDelegate.m" }, &[0][]const u8{});
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.linkLibC();
    exe.linkFramework("Foundation");
    exe.linkFramework("UIKit");
    exe.addSystemIncludeDir("/usr/include");
    exe.addLibPath("/usr/lib");
    exe.addFrameworkDir("/System/Library/Frameworks");

    exe.install();

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}/bin/app", .{b.install_path});
    defer b.allocator.free(install_path);
    b.installFile(install_path, "bin/MadeWithZig.app/app");
    b.installFile("Info.plist", "bin/MadeWithZig.app/Info.plist");
}
