class AdsbTui < Formula
  desc "Modern terminal user interface for tracking aircraft using ADS-B data"
  homepage "https://github.com/j4v3l/ADS-B_TUI"
  url "https://github.com/j4v3l/ADS-B_TUI/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ea5644e236cbf22a22fbfbe7d82a690f2a2ab42548a6aa7c01de62a8699d402a"
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
