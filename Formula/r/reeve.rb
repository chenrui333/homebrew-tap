class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "7a595f2419fff0756c62c60b40656a05fd39479cb800fdee4dd2c31c08a060fa"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
