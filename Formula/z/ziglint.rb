class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "be81fd5d9dd7cafc65c1214946c05b629d1ceb3ada31add96bfd260efea2e2fc"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c0f0daf829500e77bdd0fbdf579604718d62544dd522fcf69ed6b34e5024ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b744fddfd02a08ef56b91364aaa90e1b0a8fbce4e1c495a4646aadc4dde32dd"
    sha256 cellar: :any_skip_relocation, ventura:       "978154c406b726907a54dc42b39658a338f2fd433fe27f199f363ab8446700de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584fa198e53e522d959424fe692c72e840dade68bad0de0716ba7cbd2d1b7979"
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
