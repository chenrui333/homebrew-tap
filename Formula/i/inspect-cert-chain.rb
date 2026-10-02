class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "6d7251d1073acc3fae2299af8da338654b85e5df40e1685fe23533f35dbb77ae"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "defa9b8a6f031d5a83a4b662c0d8a9047eb2cf7f646b2c74e20a82a01fa3712a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83869d7ff6b9a695d9725cf69188989b08e1e1ec65aece4472f1b1969df6ac92"
    sha256 cellar: :any,                 arm64_linux:   "61d5b4c069e7e49e321051c0bb3a651085dc710f8088c5c8e3a6358bcfd08618"
    sha256 cellar: :any,                 x86_64_linux:  "1d216bad429e2fb5aed57cdda6b11fd6021989e49798e8a47852a55a60eb88bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    assert_match version.to_s, shell_output("#{bin}/inspect-cert-chain --version")

    output = shell_output("#{bin}/inspect-cert-chain --host example.com")
    output = output.gsub(/\e\[[0-9;]*m/, "") # Remove ANSI color codes
    assert_match(/Subject: CN=(\*\.)?example\.com/, output)
  end
end
