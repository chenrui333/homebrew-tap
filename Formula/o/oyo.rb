class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "5283d39438fa71e25a096ade1c755ca80f3eb3f2adbadd7b56936e1e83f3f197"
  license "MIT"
  revision 1
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a74f7913efbb889dc5cefe96a8b4c89d4c1637e28495d40ef828a9841f6590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78572db2028765541f494d004a6a6f48dabacd98aa8401cb00618eccdea4543d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2345a3b03f5e9543a076bf40f253cd9abdd88a40f8a047342342fa33eadc6160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c79e8b7a9e7c99b5bb859337b69e3d578d8997cebb396e88ffffedb1db1180a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50dbceb8211d3b5f668b9838f50fa065f51a47b2b28ab1f94893a2cb563e53bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
