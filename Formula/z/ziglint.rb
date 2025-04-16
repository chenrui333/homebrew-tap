class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "3d31f752aef4861e6bb6f8006309e1a61a5660f723b42797fd666093ead32402"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2164015d2ad2508e18324520ba9c13cdc44240b007b8cc688ce343883b1ffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7acf236324d7f7914b53020542027d9452f0d31e06ba9c9e9643da90306a2f37"
    sha256 cellar: :any_skip_relocation, ventura:       "f279358c0d347e06cb6026d76a8e53d4bd9d0e6e9eb33f322e32b2977a0547f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24063b58ce9186a2f0afc471807f12ab0c46edce40544679be1a097c8bd47a0e"
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
