class Seednaut < Formula
  desc "Inspect and extract Seedvault backups"
  homepage "https://github.com/Baltram/seednaut"
  url "https://github.com/Baltram/seednaut/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "ee840d495e46b4e24a8f1778df7be18e55c1a493b334c03fdd3d1729bcca818b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Baltram/seednaut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "905d6363380cef0958d8e7bfe8dfb39f98a6d017383501d7310dd113d29b719b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b893750fa94554b0fab57576f5d177ca8e43326a5e3918794fb558199bbf937"
    sha256 cellar: :any,                 arm64_linux:   "36a79aceb2e83428d6aa2180f56b94418c676ca9c9ecf07327821a366322f8f6"
    sha256 cellar: :any,                 x86_64_linux:  "cd87a2a67387970b4d2b3fd7c5a25360bf1f5bb79f2a7fe7c0ea816f88e98c52"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seednaut --version")
    output = shell_output("#{bin}/seednaut list #{testpath}/missing 2>&1", 1)
    assert_match "The specified input path does not exist", output
  end
end
