class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "672497300842282660095538c2f3b03775666f75bdd9805d427abf81c496e2a8"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de8328f5dcfa258975e3d00f3819b1d0ec6efe62e9581dd76a119ac7a50bc50a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ed09c923147d5c6f2fdd301b97e32bcb9d78a35c3a77d599387301ceccb9a3"
    sha256 cellar: :any,                 arm64_linux:   "7c59bc4a824e65ea06bd19b92cfb984e21073b6aa0c724fb592f827a74e899a5"
    sha256 cellar: :any,                 x86_64_linux:  "1729f480a98f5c2b6aa4cc134976088a627ef559fac459558b21a75e59fade97"
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
