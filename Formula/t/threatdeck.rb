class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7fafb2a934a76a3c19b839149d12f12fc5ae9becfd353306f40e3c9234d1f653"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76633be7eca530d39f77e05290606d73cdc13c86860fa9b48c6d395db71158ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5936df7869e5adddb6cd9a974c8cc6e78794ecf2d6d701e0e04b121ea6ca9be"
    sha256 cellar: :any,                 arm64_linux:   "215ef03386971ec8fa2971e72a87875f75b5c66a700b931b786c939649c2b632"
    sha256 cellar: :any,                 x86_64_linux:  "4f259e50c5c13e585afc5ee96aa12b4aec5e26813504b71df9f8b1ef453da304"
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
