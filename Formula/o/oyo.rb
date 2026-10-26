class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "7d37e77499917cbaac6f8fa730a47299772ff8b66038b0ec397980e491b2f66c"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c56b3b980236bfe56f39738291719a63b39ac35fc02af2658a5db6177a9bc646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ea4e7b812a5ce30a4a7f6e491040e168075f4daffd980a0a255dd18552201f"
    sha256 cellar: :any,                 arm64_linux:   "13e462df33c7693c918589ab07cd8656bccdebecec3a1ed444a2a833cc2c1a23"
    sha256 cellar: :any,                 x86_64_linux:  "2255d3c99c428303fd40efec7ef9f31a526384f4d4b7e870311eb63e9204987b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
