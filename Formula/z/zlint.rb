class Zlint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d8f5e1a6a5eaa6896d3a5586ea7182473590165640e859f9542c8b3efcadc67a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8019602cf52ae0eba0f69db85b1baa915423ed856d66d046c7c18ff1540d20af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "717ce2e9e8ec4185216bce0523f219fb8f1a6e68c9b898f22e1773b43cc24635"
    sha256 cellar: :any_skip_relocation, ventura:       "7db39349cd3bd2f4d7e252e89daebbe7aebbc9a03c8e270eb3b8255b6b74dc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a227290b147d46626dc5334b8a2075457b7039c30b0af2bc787d0620d99705ea"
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
