class ZigAT010 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"

  stable do
    url "https://ziglang.org/download/0.10.1/zig-0.10.1.tar.xz"
    sha256 "69459bc804333df077d441ef052ffa143d53012b655a51f04cfef1414c04168c"

    on_macos do
      # We need to make sure there is enough space in the MachO header when we rewrite install names.
      # https://github.com/ziglang/zig/issues/13388
      patch :DATA
    end
  end

  livecheck do
    skip "versioned formula"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIG_STATIC_LLVM=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end

__END__
diff --git a/build.zig b/build.zig
index e5e80b4..1da6892 100644
--- a/build.zig
+++ b/build.zig
@@ -154,6 +154,7 @@ pub fn build(b: *Builder) !void {

     exe.stack_size = stack_size;
     exe.strip = strip;
+    exe.headerpad_max_install_names = true;
     exe.sanitize_thread = sanitize_thread;
     exe.build_id = b.option(bool, "build-id", "Include a build id note") orelse false;
     exe.install();
diff --git a/src/link/MachO/Dylib.zig b/src/link/MachO/Dylib.zig
index 1c1842a..41813aa 100644
--- a/src/link/MachO/Dylib.zig
+++ b/src/link/MachO/Dylib.zig
@@ -9,12 +9,14 @@ const macho = std.macho;
 const math = std.math;
 const mem = std.mem;
 const fat = @import("fat.zig");
+const tapi = @import("../tapi.zig");
 
 const Allocator = mem.Allocator;
 const CrossTarget = std.zig.CrossTarget;
-const LibStub = @import("../tapi.zig").LibStub;
+const LibStub = tapi.LibStub;
 const LoadCommandIterator = macho.LoadCommandIterator;
 const MachO = @import("../MachO.zig");
+const Tbd = tapi.Tbd;
 
 id: ?Id = null,
 weak: bool = false,
@@ -245,7 +247,8 @@ const TargetMatcher = struct {
             .allocator = allocator,
             .target = target,
         };
-        try self.target_strings.append(allocator, try targetToAppleString(allocator, target));
+        const apple_string = try targetToAppleString(allocator, target);
+        try self.target_strings.append(allocator, apple_string);
 
         const abi = target.abi orelse .none;
         if (abi == .simulator) {
@@ -268,22 +271,29 @@ const TargetMatcher = struct {
         self.target_strings.deinit(self.allocator);
     }
 
-    fn targetToAppleString(allocator: Allocator, target: CrossTarget) ![]const u8 {
-        const cpu_arch = switch (target.cpu_arch.?) {
+    inline fn cpuArchToAppleString(cpu_arch: std.Target.Cpu.Arch) []const u8 {
+        return switch (cpu_arch) {
             .aarch64 => "arm64",
             .x86_64 => "x86_64",
             else => unreachable,
         };
-        const os_tag = @tagName(target.os_tag.?);
-        const target_abi = target.abi orelse .none;
-        const abi: ?[]const u8 = switch (target_abi) {
+    }
+
+    inline fn abiToAppleString(abi: std.Target.Abi) ?[]const u8 {
+        return switch (abi) {
             .none => null,
             .simulator => "simulator",
             .macabi => "maccatalyst",
             else => unreachable,
         };
-        if (abi) |x| {
-            return std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ cpu_arch, os_tag, x });
+    }
+
+    fn targetToAppleString(allocator: Allocator, target: CrossTarget) ![]const u8 {
+        const cpu_arch = cpuArchToAppleString(target.cpu_arch.?);
+        const os_tag = @tagName(target.os_tag.?);
+        const target_abi = abiToAppleString(target.abi orelse .none);
+        if (target_abi) |abi| {
+            return std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ cpu_arch, os_tag, abi });
         }
         return std.fmt.allocPrint(allocator, "{s}-{s}", .{ cpu_arch, os_tag });
     }
@@ -303,7 +313,26 @@ const TargetMatcher = struct {
     }
 
     fn matchesArch(self: TargetMatcher, archs: []const []const u8) bool {
-        return hasValue(archs, @tagName(self.target.cpu_arch.?));
+        return hasValue(archs, cpuArchToAppleString(self.target.cpu_arch.?));
+    }
+
+    fn matchesTargetTbd(self: TargetMatcher, tbd: Tbd) !bool {
+        var arena = std.heap.ArenaAllocator.init(self.allocator);
+        defer arena.deinit();
+
+        const targets = switch (tbd) {
+            .v3 => |v3| blk: {
+                var targets = std.ArrayList([]const u8).init(arena.allocator());
+                for (v3.archs) |arch| {
+                    const target = try std.fmt.allocPrint(arena.allocator(), "{s}-{s}", .{ arch, v3.platform });
+                    try targets.append(target);
+                }
+                break :blk targets.items;
+            },
+            .v4 => |v4| v4.targets,
+        };
+
+        return self.matchesTarget(targets);
     }
 };
 
@@ -346,11 +375,7 @@ pub fn parseFromStub(
     defer matcher.deinit();
 
     for (lib_stub.inner) |elem, stub_index| {
-        const is_match = switch (elem) {
-            .v3 => |stub| matcher.matchesArch(stub.archs),
-            .v4 => |stub| matcher.matchesTarget(stub.targets),
-        };
-        if (!is_match) continue;
+        if (!(try matcher.matchesTargetTbd(elem))) continue;
 
         if (stub_index > 0) {
             // TODO I thought that we could switch on presence of `parent-umbrella` map;
