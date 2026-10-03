class Btczee < Formula
  desc "Bitcoin protocol implementation in Zig"
  homepage "https://github.com/zig-bitcoin/btczee"
  url "https://github.com/zig-bitcoin/btczee/archive/43843338c5749920f552c7ce68f73907917fab47.tar.gz" # for zig 0.13.0
  version "0.0.1"
  sha256 "6cc91885b492fdff6e4832ce2838a8b523847f9f1a9d9fd17a8b8f6301ba32ba"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e9bdbae452dc7a3ad1068edb15aef4863f0329f4db787e5a3b8c3125fbaea7"
  end

  depends_on "zig@0.13" => :build

  # Pin dependencies to immutable commits compatible with Zig 0.13.
  patch :DATA

  deny_network_access!

  def fetch
    configure_zig_sdk
    system "zig", "build", "--fetch"
  end

  def install
    configure_zig_sdk
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

  def configure_zig_sdk
    on_macos do
      developer_dir = buildpath/"CommandLineTools"
      (developer_dir/"SDKs").mkpath
      (developer_dir/"usr").make_symlink "#{MacOS::CLT::PKG_PATH}/usr" unless (developer_dir/"usr").exist?
      ENV["DEVELOPER_DIR"] = developer_dir.to_s
      ENV["HOMEBREW_DEVELOPER_DIR"] = developer_dir.to_s
    end
  end

  test do
    # FIXME: Upstream does not expose a version command; add a version assertion when available.
    assert_match "Usage: btczee [command] [args]", shell_output("#{bin}/btczee help")
    assert_match "Wallet creation not implemented yet", shell_output("#{bin}/btczee wallet create")
  end
end

__END__
--- a/build.zig.zon
+++ b/build.zig.zon
@@ -19,12 +19,12 @@
             .hash = "122062d301a203d003547b414237229b09a7980095061697349f8bef41be9c30266b",
         },
         .libxev = .{
-            .url = "https://github.com/mitchellh/libxev/archive/main.tar.gz",
+            .url = "https://github.com/mitchellh/libxev/archive/b8d1d93e5c899b27abbaa7df23b496c3e6a178c7.tar.gz",
             .hash = "1220612bc023c21d75234882ec9a8c6a1cbd9d642da3dfb899297f14bb5bd7b6cd78",
         },
         .httpz = .{
-            .url = "https://github.com/karlseguin/http.zig/archive/zig-0.13.tar.gz",
-            .hash = "12208c1f2c5f730c4c03aabeb0632ade7e21914af03e6510311b449458198d0835d6",
+            .url = "https://github.com/karlseguin/http.zig/archive/2a910af45a6a733adbcf9e5e56642c05f4f5c769.tar.gz",
+            .hash = "12203254adcaba63705ff7ecf1894a5a26d5a5a0a9cfecd01423775fa5566b625138",
         },
     },
     .paths = .{
