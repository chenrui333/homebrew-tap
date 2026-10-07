class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "bd5975933615483f2f7cd108ce8c9143c038a614d989f0237e535d7d54c4e966"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34773149d55090f8d0930d677ce765524c11360e38483848c18771b72e804588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "038e2574ed2b8f73f6f984a7838276b57ae93fa8b7d99d1143f5cb9aa54fa03f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3d1dd643c7df33d197ddf58b28ff74dbbd06de16ce05e1c26a14a881c8ddf84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cc048ca82279632ed78c89ac98607b7bef2d1221b8f80003131c1f2c64f7ba"
  end

  depends_on "zig@0.16" => :build

  deny_network_access!

  def fetch
    system formula_opt_bin("zig@0.16")/"zig", "build", "--fetch"
  end

  def install
    args = ["-Dversion=#{version}"]

    zig = formula_opt_bin("zig@0.16")/"zig"
    system zig, "build", *args, *std_zig_args(release_mode: :fast)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zlint --version")

    (testpath/"valid.zig").write <<~ZIG
      pub fn main() void {}
    ZIG

    output = shell_output("#{bin}/zlint #{testpath}/valid.zig 2>&1")
    assert_match "Found \e[33m0\e[39m errors and \e[33m0\e[39m warnings", output
  end
end
