class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "35383fb834d5ef916ea842a5bd88faa02b20c81e27850d5b281133be777565fd"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de475dff3d65a215dfc9bf6655b5dbd304c6b667c8761a1b257273b96ecb9351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbaeb0a28c183220d7840111f75a5119e49f66b845258e9d0fe2c0cf7bc54142"
    sha256 cellar: :any,                 arm64_linux:   "acf38da83afd6cb062f50a579a3ee916382fa5fb8b73b7e74d141f8bc997da8d"
    sha256 cellar: :any,                 x86_64_linux:  "fe99dead8d213ec461fab050c2a0987f9ac0b681c3c746a437b5781026ed24ef"
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
