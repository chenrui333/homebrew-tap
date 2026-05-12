class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "bda855973e4db324e3b8536aca55d9c0a9d72ae57f97719d2105758c9f42405b"
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
