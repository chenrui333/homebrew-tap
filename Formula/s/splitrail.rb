class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "269135c81fad533f6bd2c14ed1cf1f17d4c1ddf3e3be40adeb1c92dc1788b78f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff5cf12f0a74649ccddb7537c47e0014ff2ce307c94cfc1cd036053c97c9c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48a688972b108efec11246b56f5471335c6ea766c0b4d17761bc305503b6f625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ab5c4733b83fe645c0fc4fb90a7c017570432e327d2c8f7bec5f7170d8293d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd369325aabe5339b87440fdb9873ecc386946b902abf41695d2d594b5f1f1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aadd78bdd91777de170392068734b832f3662538985670dc260c0b4003fcbba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
