class Btczee < Formula
  desc "Bitcoin protocol implementation in Zig"
  homepage "https://github.com/zig-bitcoin/btczee"
  url "https://github.com/zig-bitcoin/btczee/archive/43843338c5749920f552c7ce68f73907917fab47.tar.gz" # for zig 0.13.0
  version "0.0.1"
  sha256 "6cc91885b492fdff6e4832ce2838a8b523847f9f1a9d9fd17a8b8f6301ba32ba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22fb8c18aaf164b87c77336c5cdebdf93407c4c8c6b65f07226083ecec12268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b8e2edcc1703887eafe3b7d092d3b1e6bf49c43600274d2fed8d358d5aca5e"
    sha256 cellar: :any_skip_relocation, ventura:       "0c4d747d85bfb2512813ed0fccec4c67f5348c8c7c6ad93d13e516b41070bd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a43193f9d51b82e0bbe95e541a4f53960b65339548945482e116bf9c3ed9e4b"
  end

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
