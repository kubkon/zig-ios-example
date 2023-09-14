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
            break :blk sdk;
        },
        else => {
            @panic("Missing path to Apple SDK");
        },
    };
    b.sysroot = sdk;

    const lib = b.addStaticLibrary(.{
        .name = "main",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(.{ .cwd_relative = "." });

    lib.addSystemFrameworkPath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/System/Library/Frameworks" }) });
    lib.addSystemIncludePath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/usr/include" }) });
    lib.addLibraryPath(.{ .path = b.pathJoin(&.{ b.sysroot.?, "/usr/lib" }) });

    const install_lib = b.addInstallArtifact(lib, .{});
    b.default_step.dependOn(&install_lib.step);
}
