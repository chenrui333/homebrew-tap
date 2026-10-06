class Rustlens < Formula
  desc "Blazing-fast Rust code inspector for the terminal"
  homepage "https://github.com/yashksaini-coder/Rustlens"
  url "https://github.com/yashksaini-coder/Rustlens/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3c5729600ad797b1e9e69cae57ba3b60a617bec3f30c27c975ef9d32b70052e1"
  license "MIT"
  head "https://github.com/yashksaini-coder/Rustlens.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bd0554d57b05f1db756b6ccdc784a27e5eb8df8912984e05bd18080ffd22f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca12fc64877c8f8c6604c103a8c75b846556df8b5231e8cd98c6763f453be2ed"
    sha256 cellar: :any,                 arm64_linux:   "a9b4fd333a38d8ce6194cafe2e4d6da22c2066b0bbc1880501928485c463259c"
    sha256 cellar: :any,                 x86_64_linux:  "27d93c26f41a4acd53dfd071043fcfcc9a8ee13f32c77a71d43a0dde2d7bd72e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_path_exists bin/"rustlens"
  end
end
