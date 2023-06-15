const std = @import("std");
const Allocator = std.mem.Allocator;
const Builder = std.Build;

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    if (b.sysroot == null) {
        std.log.warn("You haven't set the path to Apple SDK which may lead to build errors.", .{});
        std.log.warn("Hint: you can the path to Apple SDK with --sysroot <path> flag like so:", .{});
        std.log.warn("  zig build --sysroot $(xcrun --sdk iphoneos --show-sdk-path) -Dtarget=aarch64-ios", .{});
    }

    const exe = b.addExecutable(.{ .name = "app", .root_source_file = .{ .path = "main.zig" }, .target = target, .optimize = optimize });
    exe.addIncludePath(".");
    exe.addCSourceFiles(&[_][]const u8{ "AppMain.m", "AppDelegate.m" }, &[0][]const u8{});
    exe.linkLibC();
    exe.addFrameworkPath("/System/Library/Frameworks");
    exe.linkFramework("Foundation");
    exe.linkFramework("UIKit");
    exe.addSystemIncludePath("/usr/include");
    exe.addLibraryPath("/usr/lib");

    const install_bin = b.addInstallArtifact(exe);
    install_bin.step.dependOn(&exe.step);

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}/bin/app", .{b.install_path});
    defer b.allocator.free(install_path);

    const install_exe = b.addInstallFile(.{ .path = install_path }, "bin/MadeWithZig.app/app");
    const install_plist = b.addInstallFile(.{ .path = "Info.plist" }, "bin/MadeWithZig.app/Info.plist");

    install_plist.step.dependOn(&install_bin.step);
    install_exe.step.dependOn(&install_plist.step);

    b.default_step.dependOn(&install_exe.step);
}
