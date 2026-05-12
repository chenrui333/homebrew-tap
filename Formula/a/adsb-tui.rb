class AdsbTui < Formula
  desc "Modern terminal user interface for tracking aircraft using ADS-B data"
  homepage "https://github.com/j4v3l/ADS-B_TUI"
  url "https://github.com/j4v3l/ADS-B_TUI/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cfaec5443f30eeaa1908b7587695f219ff0b4cdf6c5967047f145fc50ac7375e"
  license :cannot_represent
  head "https://github.com/j4v3l/ADS-B_TUI.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "adsb", shell_output("#{bin}/adsb-tui --help 2>&1")
  end
end
