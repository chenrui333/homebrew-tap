class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "9da66fec4b30c44ad173cfa4dc775caeaef3f8ecba3b4b62d11db5e01d9aa006"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c933a66854994cf4c3689b2b8a86266a3ca42adb119a78c72564255fa83f56f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994afbf6197b1a9a24bb1af4be30554dd0a0daca347c13c649bfc9c1fe07e8f1"
    sha256 cellar: :any_skip_relocation, ventura:       "f0812ddea9596357cd9502e4edd7193d34570b8a14b7a2a4314476c2ed352885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc2d952fac16da15a9f7576502c0e685b564d6caff84a99c9c3fcced97b4f64"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
      -Dversion=#{version}
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    (testpath/"valid.zig").write <<~ZIG
      const std = @import("std");

      pub fn main() void {
          const message = "Hello, world!";
          std.debug.print("{s}\\n", .{message});
      }
    ZIG

    output = shell_output("#{bin}/zlint #{testpath}/valid.zig 2>&1")
    assert_match "Found \e[33m0\e[39m errors and \e[33m0\e[39m warnings", output

    assert_match version.to_s, shell_output("#{bin}/zlint --version")
  end
end
