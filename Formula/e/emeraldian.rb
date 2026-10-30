class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "2d6911759dcf947cac9428b1b83ee12114057275d15353219288af6d2ad47cc0"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84ba32040e658e45bd47a6706263980453f6a4ea2b2ab3bd2629446bf67bcae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc364a682c365fb26abf481dfb8a104f4c9b7011083bd3119c2cfe0fe31a3318"
    sha256 cellar: :any,                 arm64_linux:   "7a742b6c5cb99079888188fef2a6e0cbfb4fd5b7663387bdab0a426e41b10bd6"
    sha256 cellar: :any,                 x86_64_linux:  "d8845ac1880f622ecad8684503d6987739a03ef80d8d78cea5c48fb50061f78a"
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
