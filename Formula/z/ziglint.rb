class Ziglint < Formula
  desc "Linter for the Zig programming language"
  homepage "https://github.com/DonIsaac/zlint"
  url "https://github.com/DonIsaac/zlint/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "bd5975933615483f2f7cd108ce8c9143c038a614d989f0237e535d7d54c4e966"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f55b5d058990b32ed49e0d349ec43811a477049b0d279979e8cdf765d6b9d109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852ffe9bbe03252e204d2f7c69a8ba40813dbd23e6f319725638e61a013cc506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ecf2a9232222f4d4c7b9b3e3ebd3240090caa930ade737b1d703fca52d6fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f8e037826afa5ea500456713fc1dc3b76d193b6af8e2f674c410aa5600a6d7"
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
      pub fn main() void {}
    ZIG

    output = shell_output("#{bin}/zlint #{testpath}/valid.zig 2>&1")
    assert_match "Found \e[33m0\e[39m errors and \e[33m0\e[39m warnings", output
  end
end
