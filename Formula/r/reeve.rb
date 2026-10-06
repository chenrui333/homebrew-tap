class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0e217718bdb3d7a1dfeb5a3e5ba3d2d7636cba03485d1b78c8173fe285a8cd28"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de53386c1b91e45a9f4c0edb01007a889bb0baf3d57a9a61496f6a859320eae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5031583dca6cd44609597d226d0cb0c73158fa782041e570ff9657f15fe47f9"
    sha256 cellar: :any,                 arm64_linux:   "aa0c982fc1318982219cb3c80ee03c0c3da5287a72ed074b98886787d1643ff2"
    sha256 cellar: :any,                 x86_64_linux:  "c46e4fe4a32798ef6c907d8320fde3b1983cd59d5644ee464d7773684e52d8f7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
