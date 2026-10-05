class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7fafb2a934a76a3c19b839149d12f12fc5ae9becfd353306f40e3c9234d1f653"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3632e469c6abd66a4dd4f1c89a7aefce85021caaba009a2facb1067b460faa3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32a14fe2ed5f983b504961e7d4605b5b9bff73491ac4fadb9ac6931346bcb6af"
    sha256 cellar: :any,                 arm64_linux:   "969346e649949c67e85bbf447cec83fe9bf03aa21b2d19c4e4686393a4ab9af7"
    sha256 cellar: :any,                 x86_64_linux:  "f870d40dd4b6344f13cd7bf1e123f96b6d8635594c09587f5659e6eceaf38be8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
