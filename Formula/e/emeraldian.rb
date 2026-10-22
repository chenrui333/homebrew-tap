class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e6603dbc31f086db5ca2afcbd6c12657b9f54fbad1879ef655bfe261ddb4bfc4"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54dc82cc327c3602e407ddb7799252f5c1ea46e1e21d3af1d4965f9dfacebc6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2d857e7b9f35550852c696969276029d67b323e89a5d3ec4974f8315388441"
    sha256 cellar: :any,                 arm64_linux:   "4fa45770a9cd8e21ef46775da6e4f1ba0ef9fc797e952ccf07063a991d19e667"
    sha256 cellar: :any,                 x86_64_linux:  "5120ecb3e85b32e702ef979ed054ff26da8b8315fb8d184a91315112e4f4ad2b"
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
