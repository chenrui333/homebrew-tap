class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "00315681f098627da778c98362031fb2fcaa4bb0d49f3494d9a6783f77f887f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33718213ddaebfbfbf6c59b7a9ab74cbb0d2eff25d281e266496a0ded7ae6857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c86eade488e5a2eab192fc43f423b49bc042a6b31738a8dec8b7fc95e6d4f1"
    sha256 cellar: :any_skip_relocation, ventura:       "422abe67865e41c7edd274c339c4aaf288d4a6c02a4e3da3a77cd2863230dad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1ed431262dbbfd81be21d52302f114543108ef678cfc70b934ae74fb9beb40"
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
