class Minisign < Formula
  desc "Tool to sign files and verify digital signatures"
  homepage "https://github.com/jedisct1/minisign"
  url "https://github.com/jedisct1/minisign/archive/refs/tags/0.12.tar.gz"
  sha256 "796dce1376f9bcb1a19ece729c075c47054364355fe0c0c1ebe5104d508c7db0"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f12c8feffdf9709660d263c3f5504014d8624d3bf22ffb31ce36c6b6b0a52a23"
    sha256 cellar: :any,                 arm64_sonoma:  "9ce25d0354ba986b6f8862440d8be83caff4d552d57499551f275fa3429a2d9a"
    sha256 cellar: :any,                 ventura:       "29cd2658c5f30c04f48683dc2cba3e77f9a55606c766f249192805d65e3a841c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b033fcf9d9dd1514960a6fe3f9caa34d71cf120ac183f65c6b550da6049a8b1"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "libsodium"

  patch :DATA

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minisign -v")

    (testpath/"testfile.txt").write "Hello from minisign test!"

    # Generate a new key pair (disable passphrase with -W).
    system bin/"minisign", "-G",
                          "-p", testpath/"public.key",
                          "-s", testpath/"secret.key",
                          "-W"

    # Sign the test file with our newly generated secret key.
    system bin/"minisign", "-S",
                          "-m", testpath/"testfile.txt",
                          "-x", testpath/"testfile.sig",
                          "-s", testpath/"secret.key",
                          "-W"

    # Verify the signature using our newly generated public key.
    system bin/"minisign", "-V",
                          "-m", testpath/"testfile.txt",
                          "-x", testpath/"testfile.sig",
                          "-p", testpath/"public.key"
  end
end

__END__
diff --git a/build.zig b/build.zig
index 0951668..637f52a 100644
--- a/build.zig
+++ b/build.zig
@@ -5,7 +5,6 @@ pub fn build(b: *std.Build) !void {
     const optimize = b.standardOptimizeOption(.{});
 
     const use_libzodium = b.option(bool, "without-libsodium", "Use the zig standard library instead of libsodium") orelse false;
-    const use_static_linking = b.option(bool, "static", "Statically link the binary") orelse false;
 
     const minisign = b.addExecutable(.{
         .name = "minisign",
@@ -13,17 +12,17 @@ pub fn build(b: *std.Build) !void {
         .optimize = optimize,
         .strip = true,
     });
+
+    minisign.headerpad_max_install_names = true;
+
     minisign.linkLibC();
     if (use_libzodium) {
-        const libzodium_mod = b.createModule(.{
-            .root_source_file = b.path("src/libzodium.zig"),
-            .target = target,
-            .optimize = optimize,
-        });
         const libzodium = b.addStaticLibrary(.{
             .name = "zodium",
-            .root_module = libzodium_mod,
             .strip = true,
+            .root_source_file = b.path("src/libzodium/libzodium.zig"),
+            .target = target,
+            .optimize = optimize,
         });
         libzodium.linkLibC();
         b.installArtifact(libzodium);
@@ -31,10 +30,10 @@ pub fn build(b: *std.Build) !void {
         minisign.linkLibrary(libzodium);
     } else {
         minisign.root_module.linkSystemLibrary(
-            "sodium",
+            "libsodium",
             .{
                 .use_pkg_config = .yes,
-                .preferred_link_mode = if (use_static_linking) .static else .dynamic,
+                .preferred_link_mode = .dynamic,
             },
         );
     }
