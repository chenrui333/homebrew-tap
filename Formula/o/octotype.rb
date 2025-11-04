class Octotype < Formula
  desc "TUI typing trainer inspired by monkeytype with a focus on customization"
  homepage "https://github.com/mahlquistj/octotype"
  url "https://github.com/mahlquistj/octotype/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5015c5e9a53609ce5554f98c814b37f6dde0e3b3c515b453bfc1e7999d6a66bc"
  license "MIT"
  head "https://github.com/mahlquistj/octotype.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octotype --version")

    output = shell_output("#{bin}/octotype --print-config")
    assert_match "disable_ghost_fade = false", output
  end
end
