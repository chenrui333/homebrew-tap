class Btczee < Formula
  desc "Bitcoin protocol implementation in Zig"
  homepage "https://github.com/zig-bitcoin/btczee"
  url "https://github.com/zig-bitcoin/btczee/archive/43843338c5749920f552c7ce68f73907917fab47.tar.gz" # for zig 0.13.0
  version "0.0.1"
  sha256 "6cc91885b492fdff6e4832ce2838a8b523847f9f1a9d9fd17a8b8f6301ba32ba"
  license "MIT"

  depends_on "zig" => :build

  # patch sha for libxev, httpz
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
    assert_match "Usage: btczee [command] [args]", shell_output("#{bin}/btczee help")
    assert_match "Wallet creation not implemented yet", shell_output("#{bin}/btczee wallet create")
  end
end

__END__
diff --git a/build.zig.zon b/build.zig.zon
index ea0f537..7006144 100644
--- a/build.zig.zon
+++ b/build.zig.zon
@@ -20,11 +20,11 @@
         },
         .libxev = .{
             .url = "https://github.com/mitchellh/libxev/archive/main.tar.gz",
-            .hash = "1220612bc023c21d75234882ec9a8c6a1cbd9d642da3dfb899297f14bb5bd7b6cd78",
+            .hash = "1220ebf88622c4d502dc59e71347e4d28c47e033f11b59aff774ae5787565c40999c",
         },
         .httpz = .{
             .url = "https://github.com/karlseguin/http.zig/archive/zig-0.13.tar.gz",
-            .hash = "12208c1f2c5f730c4c03aabeb0632ade7e21914af03e6510311b449458198d0835d6",
+            .hash = "12203254adcaba63705ff7ecf1894a5a26d5a5a0a9cfecd01423775fa5566b625138",
         },
     },
     .paths = .{
