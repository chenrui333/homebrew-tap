class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "334bf01aabc67b276b8a6cae6fe7c1d4b2c679be33358ab76416d4cf64cce4d6"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a4ab6b3025c81b1d38690c7ad598283494f974ef5900b522bf6c73b10e9918f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57088eba5405b13a339d9d5778ccbd893e5e8b8e19210168b2c8eb5c1f71d4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd4ec32ed456efd5db5783e71313ac693db51a5b46640802459a64ebf813731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ce2578bdefcf8df9195d4001ce2b06432278ff2478f4933ba11f762ab4ca92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97212d6dc7006457eaa3e170ea52b961e7f15161d773ff2b443a6fec9dd94f9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
