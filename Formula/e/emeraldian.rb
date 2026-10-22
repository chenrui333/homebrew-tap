class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a7972c9b0eef89a01543cb80c00828d3b274f139751be6838496cf32c50eebe6"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd1975ff6d6c0a827a7574a8185ab5c9e30001abd02c0a83578012ea0f44a073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f2fa6591c7309c1ff62a6702d29dbb229d013831e6373b085f0ccadad90823"
    sha256 cellar: :any,                 arm64_linux:   "b521a707bdbe4a061f8301f3dec506641e945c836fea26f468ce5c3a0449de4a"
    sha256 cellar: :any,                 x86_64_linux:  "c36cd1e0335c8759c5bba7ccca3ac6b597286192854ef19b4b86b03091c3bf8a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emeraldian")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emeraldian --version")

    assert_equal "No vaults are registered with Obsidian on this machine.\n",
      shell_output("#{bin}/emeraldian --list-vaults")
  end
end
