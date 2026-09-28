class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.7.30.tar.gz"
  sha256 "e7e046e563185f1e73bae5347699b57fb501855e47adbbcbb00a17e266520024"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9efb99e94de1a315ca508deed78ea27bf61d07a423f6ab70302af7111825ae22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543421610100400da9208c716d5f7939d4170b8e95dd9fd68c7bbfb7d51ef9e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51dcac8bb5a15d675208a8ef24a85c948a6b49a98ef6162e18f976bae04d38f"
    sha256 cellar: :any,                 arm64_linux:   "63c1723fe1d61239cd2d5eb271f0cf186aeec1687e31ca13e23968c9f04020b1"
    sha256 cellar: :any,                 x86_64_linux:  "65121f2f037cb37a2b1078384737447bc14cc28aec99d431a2912ce57b2ac30c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codemark-cli")
    generate_completions_from_executable(bin/"codemark", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codemark --version")
    assert_match "rust", shell_output("#{bin}/codemark languages list").downcase
  end
end
