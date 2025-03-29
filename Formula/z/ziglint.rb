class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "9da66fec4b30c44ad173cfa4dc775caeaef3f8ecba3b4b62d11db5e01d9aa006"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec2e00d9f6d531da9d38a5b7761273d92ee1ebb7dea949631f1d3df0c028dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c0c7ae354bec05b25c8e594d6da29196357d8b2156ad20a780e039792934162"
    sha256 cellar: :any_skip_relocation, ventura:       "4b9a95d0435bf2e979d48e41ac299f4b813e42b1104dd21d86938e67ec9081b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbc5ad487959f101bf261c322bfe1210b6d5c2681b39e4458a9209cad21cc04"
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
