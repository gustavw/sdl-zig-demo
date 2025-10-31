const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "sdl_zig_demo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    switch (target.result.os.tag) {
        .macos, .linux => {
            exe.linkSystemLibrary("SDL2");
            exe.linkLibC();
        },
        .windows => {
            exe.linkSystemLibrary("SDL2main");
            exe.linkSystemLibrary("SDL2");
        },
        else => {},
    }

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the demo");
    run_step.dependOn(&run_cmd.step);
}
