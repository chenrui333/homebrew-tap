class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "f64ed60a7b5fb67679b7eb24ffedc1a20ab80546e588c8b943c06cd2e7fd0900"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3635d2f6ee37883a521eb005dac7898a8106f5c20ca4e988a828e7417fce7f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "005901840c5dc86fe1a2864bdb3a43e8fff21b13cc0648b570f991300d7c78ff"
    sha256 cellar: :any,                 arm64_linux:   "c65b6481b0d8adc48a728f7b023b8721de4bbab482b8ceac7db956f0f6845295"
    sha256 cellar: :any,                 x86_64_linux:  "f9b58b37d1f42aadec301de9db50d4f432077df505036d6184476cf12fe091af"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
