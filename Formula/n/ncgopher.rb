class Ncgopher < Formula
  desc "Ncurses gopher and gemini client"
  homepage "https://github.com/jansc/ncgopher"
  url "https://github.com/jansc/ncgopher/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c91b139fd3ec89dd1c20c75350de1a21624c03b16d086d9e7dd4e5dd8c829761"
  license "BSD-2-Clause"
  head "https://github.com/jansc/ncgopher.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9fa91122bc95796047d60ce5efbb05d8f77c97954b928d68f30f4e875a0253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96831c68da841819e221cf3d823d5389cdcd99755969e77ae90e4d37c96cb7bd"
    sha256 cellar: :any,                 arm64_linux:   "6d4312f3b116949c6a0d530c947e0ab14d5bb7d1fb8b2abdf0a07833a670da4a"
    sha256 cellar: :any,                 x86_64_linux:  "e0d122261548dbade234ed538282b6350b0fd5fe28672be54843e84c6e0a6141"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ncurses"
  depends_on "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncgopher --version")

    output = shell_output("#{bin}/ncgopher 'not a URL' 2>&1", 101)
    assert_match "Invalid URL: not a URL", output
  end
end
