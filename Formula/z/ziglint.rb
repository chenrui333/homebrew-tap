class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "28446974e0a2f4459b08692167a48ca608fd72f5811297a69c6151a8e6977f58"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "641ded123951aac04597478504b3b0135a3520308dfc87d45f3a33fc566d8266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "572f0d0451d2e008ad341cad6e767fcc859a24a7623b43619e9aaa1e3830cd79"
    sha256 cellar: :any_skip_relocation, ventura:       "554b3180025c3d3f89a14392acd45143be491912f28274e887ebb35a83a3e3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "533616583aba0d4b87abff9a0db28361666b2f27278c388bed84775e25a6c60e"
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
