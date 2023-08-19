const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const Builder = std.Build;

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const sdk = if (b.sysroot) |sysroot| sysroot else switch (builtin.os.tag) {
        .macos => blk: {
            const target_info = std.zig.system.NativeTargetInfo.detect(target) catch
                @panic("Couldn't detect native target info");
            const sdk = std.zig.system.darwin.getSdk(b.allocator, target_info.target) orelse
                @panic("Couldn't detect Apple SDK");
            break :blk sdk.path;
        },
        else => {
            @panic("Missing path to Apple SDK");
        },
    };
    b.sysroot = sdk;

    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .cwd_relative = "." });
    exe.addCSourceFiles(&[_][]const u8{ "AppMain.m", "AppDelegate.m" }, &[0][]const u8{});
    exe.linkLibC();
    exe.linkFramework("Foundation");
    exe.linkFramework("UIKit");

    exe.addSystemFrameworkPath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/System/Library/Frameworks" }) });
    exe.addSystemIncludePath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/usr/include" }) });
    exe.addLibraryPath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/usr/lib" }) });

    const install_bin = b.addInstallArtifact(exe, .{});
    install_bin.step.dependOn(&exe.step);

    const install_path = try std.fmt.allocPrint(b.allocator, "{s}/bin/app", .{b.install_path});
    defer b.allocator.free(install_path);

    const install_exe = b.addInstallFile(.{ .path = install_path }, "bin/MadeWithZig.app/app");
    const install_plist = b.addInstallFile(.{ .path = "Info.plist" }, "bin/MadeWithZig.app/Info.plist");

    install_plist.step.dependOn(&install_bin.step);
    install_exe.step.dependOn(&install_plist.step);

    b.default_step.dependOn(&install_exe.step);
}
