class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "69c8084740fc1ec3cc2f2fc4c9fa8cdbbc73f390bb13467e924eba2ed2351f48"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1940ed346d26b211bb5d3e927c1e862da31e054aa0625dbe3c8f18ecfa0bff45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c85a9cb36bbf2d70bce098754e5976e1eb946fd4397529bcea3e31f4936b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eb85da2671c61122c11a0cf81e4215d98011370f63733b83ae91455ec363d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985eebd8e10ec5535c472ed1b756ac76916e5ce569974d48bbed1c0f94988bb6"
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
