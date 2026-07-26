class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "867538996fa697d3fe797cb5b9559b37674c3d065091df373cee76c1052ff1a4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2323b65197d4696ec25eec18fd7e93c65249dc8a33d768ac6d4e57047cf9a0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bad896b9297176c84993f70851fb4801aa21fa178e6f65a73cb240cef63ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39d394fa396ae10dbf1499e47c663e2599b388fc1a33002fa66986397da3516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc09ce61555faeae315646a229bf498a83667949fb1730b601670e5e4b73bb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ca9afb70814973a4a2cbe9b4c8433d02e8a36a682ead372c3320ee68783191"
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
