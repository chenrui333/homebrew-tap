class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "598f5bd799625a8456bf851e8bc8617ecad3a7ce3ca785c551b9fb90767d3148"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a849a92aaea56ff1015de264ec48141a6d2abf64a525a5e1b5512e8aeea39cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba7d5ae52a9acced5e5e22eefa6d0f72e0829c835e13f284b3a713a3fbf6135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ac7a598f2a69360270c28ce11ccf8fa0eac3d284aad08cf92beab5718386b6"
    sha256 cellar: :any,                 arm64_linux:   "cbdec9a443e359c5c259bf1583b5e5130e587d67ce2817fcf7e316d4719cddba"
    sha256 cellar: :any,                 x86_64_linux:  "a32f01fec6bd9a83f22c3a708ce8d8c864a2b39bdc7ef4d3dacbe83bc26bef6c"
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
