class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ae5a044dab4296c42fcf918ec970f7adabcd8ea0e0fa329f526845660599e35a"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b7c2e69935cc259fd5b0b429220f7e189f5c9e65172d1a3b9cdc323db8d6ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924761ab0e626338ed25e59af431801b4705e9b0842ecc961ad98392364bbd07"
    sha256 cellar: :any,                 arm64_linux:   "d29550f133522bd0cf65c4b160402d305948629d74e8166ce008a72a35184930"
    sha256 cellar: :any,                 x86_64_linux:  "bb3a7711954dbb1f25c25e3d1cc08aa5f21f75680239e862bc33840a2ee35e3b"
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
