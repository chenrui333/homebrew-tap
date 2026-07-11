class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "4e162020f21508aa5a86201e0421d18c9f49343c5e0476ae265d9cdf4ccf3936"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab558683091a59b32d58e3622234c94a52136cfaea14d5cce059a70e0022245d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c142121eb99a0fb338503e1f68a38adc5a42afc057e81ae9b950ad62eec6b568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660d2712015d39b90cb7083b4e8d9f2514da7b43b0abe5e4ec501c9cbf751a04"
    sha256 cellar: :any,                 arm64_linux:   "4355f88346b354525940be88f1fdd840924931151fb66dbb97a9a4539aeda082"
    sha256 cellar: :any,                 x86_64_linux:  "9ef9a543480d41d37c880b8944aabb98d2de4e17e2fdc8fff187ec6731f8f53a"
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
