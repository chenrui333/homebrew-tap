class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "69c8084740fc1ec3cc2f2fc4c9fa8cdbbc73f390bb13467e924eba2ed2351f48"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c23e65a789b25b82ea7a12c0398df1f5671931a3c946d82db5e97732bfa94a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1566d4fac6d4da67843bb6297153bd6fed18edda53077fd4c23e559c87cd8f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc61f189ba89de31eeaadb0b5b1c553fd7f531bb4541601df268db7e6b048f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0b8be17181e0eb3e07db73dede49e69f53f3044173b2266ed0447ad13e9d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f0e03bf0d0461baf82144989dd8385a55e28b759f2b04abb4dbfa07a79eed4b"
  end

  depends_on "zig" => :build

  def install
    args = ["-Dversion=#{version}"]

    zig = formula_opt_bin("zig")/"zig"
    system zig, "build", *args, *std_zig_args(release_mode: :fast)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zlint --version")

    (testpath/"valid.zig").write <<~ZIG
      const std = @import("std");

      pub fn main() void {
          const message = "Hello, world!";
          std.debug.print("{s}\\n", .{message});
      }
    ZIG

    output = shell_output("#{bin}/zlint #{testpath}/valid.zig 2>&1")
    assert_match "Found \e[33m0\e[39m errors and \e[33m0\e[39m warnings", output
  end
end
