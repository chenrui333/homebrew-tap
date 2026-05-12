class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "334bf01aabc67b276b8a6cae6fe7c1d4b2c679be33358ab76416d4cf64cce4d6"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
