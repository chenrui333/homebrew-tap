class Papr < Formula
  desc "Terminal workspace for academic research"
  homepage "https://github.com/AfrozSaqlain/Papr"
  url "https://github.com/AfrozSaqlain/Papr/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "4a08d83c6d1cc98af6fbc0594581e29f995bb8e0436b78ebacd9361be9dbd1bf"
  license "MIT"
  head "https://github.com/AfrozSaqlain/Papr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e7c1aea2f072db22e099a08b65bd9411271074dcd0109e58fd47c01a7062d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20cf2b7bb52b4dff6b1eb761e7968c21e2c17bd7851e44a94153a94252cbd8c"
    sha256 cellar: :any,                 arm64_linux:   "cdf3148fd54161e453417b01d2c77e01691c561373d1ff69d6aa76045ea5a780"
    sha256 cellar: :any,                 x86_64_linux:  "99450c53f094acd4064c3b82f8e010d26ed902cf8fe3eccf6b1a4f88d86009ca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/papr")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papr --version")
    output = shell_output("#{bin}/papr paths")
    assert_match "database:", output
    assert_match "projects:", output
  end
end
