class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "c175a936adfa1ad1ddf38aeac246b8966a44999f4061d51f47a2b827745c8316"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c033ef566c149d5c900fc95979d54560fc9fd8ef39b474d5aa75412659468f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a13dc725b6f187ece808af874c80ead5f55dfdb6dae8bff9e11ab6d084b8693"
    sha256 cellar: :any_skip_relocation, ventura:       "29692d1c17610a4a995bfdb7264e3866b6bb5fee210a98cf925b5f1fce42ee41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd153b7cf5da067a951b332b8e348268063aa7e664ad1935ccf848c38aa7a218"
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
