class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "672497300842282660095538c2f3b03775666f75bdd9805d427abf81c496e2a8"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb7e52e60998fc5a459e2a79585dcf291bbc40bf208cc68a83eae1f78c52d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6676c8745b34947192cedee0f1d5c3609c6b352994920607c33fba25be59fa6c"
    sha256 cellar: :any,                 arm64_linux:   "07a3cd41ad348295770041686e5f45d6a4fd0d8845bda38664751a2ee72c3125"
    sha256 cellar: :any,                 x86_64_linux:  "d50af050d6fc35a29b5bf40e86f0f83a24a4a1af27bd93cc729ca5530e017143"
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
