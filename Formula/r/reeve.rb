class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0e217718bdb3d7a1dfeb5a3e5ba3d2d7636cba03485d1b78c8173fe285a8cd28"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f4ed23aea562f684abd2c1a932d3615dfa5ba92fa6ecf028efa7f8314d8c61e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a515255aeade5a2553c31887aa558597c202207223d6e6fe8ae9a1179a1ea394"
    sha256 cellar: :any,                 arm64_linux:   "8725ca37895ed350f9bf97f1146579568d2b84fd6ffef008af2fd66ba47085b7"
    sha256 cellar: :any,                 x86_64_linux:  "7e68d7bb49566cfa1e9d065af5abf5f41389dd962bd08105a3f3300c00bb29ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
