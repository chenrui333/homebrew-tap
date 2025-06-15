class Netscanner < Formula
  desc "Network scanner with features like WiFi scanning, packetdump and more"
  homepage "https://github.com/Chleba/netscanner"
  url "https://github.com/Chleba/netscanner/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ad2df332bb347eac96c0a5d22e9477f9a7fe4b05d565b90009cc1c3fb598b29f"
  license "MIT"
  head "https://github.com/Chleba/netscanner.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netscanner --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Requires elevated privileges for network access
    assert_match "Unable to create datalink channel", shell_output("#{bin}/netscanner 2>&1")
  end
end
