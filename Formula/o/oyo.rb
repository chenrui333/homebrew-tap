class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "699f708f88173221ad51fe138082d54cea13f219ff70f737d817be9e8b9f5275"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c15c20d1f4cbbb2bbe6f00661ee5ee75285a2283510ff727050c86b321a2d35d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420757baa6c6e4e21ce331a16172f234b7186c2213df2eb87814dbb5edb86ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7dd2cb6ba0cfef1626218355c3c245f58ee215826a2a0f8f73f2318344f6b1"
    sha256 cellar: :any,                 arm64_linux:   "84ced7ceec5967d1827b5b75e880e08a62eb1d0584c12f16a95dad6d810c143a"
    sha256 cellar: :any,                 x86_64_linux:  "fa222cf2e9b64d2fcb3c6b2f142b630f09cc892ad313020158db4a946e5bc044"
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
