class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "28446974e0a2f4459b08692167a48ca608fd72f5811297a69c6151a8e6977f58"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4925b99fd4862c61206a2bf6c88b021d106444ad5ab1281ade57db1a7e0d64c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f940f5d9cff93a2938fa3d28724ec348e71353cd1d9f585dbe6ee56d066166"
    sha256 cellar: :any_skip_relocation, ventura:       "570cc752af6ead37f287891de58da5e3cf897e49b55c7d085533d9f649b8eb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ef1b95f65e612a57a97d97eb2321b3074ea8524622395929946d2c8f6cfb5a"
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
