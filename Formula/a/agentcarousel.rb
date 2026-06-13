class Agentcarousel < Formula
  desc "Unit tests for AI agents with LLM judge scoring and signed evidence"
  homepage "https://github.com/agentcarousel/agentcarousel"
  url "https://github.com/agentcarousel/agentcarousel/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e31b3cfdd56986a70107b9489014f779119e7f16b1e7958a2352508393712a8c"
  license "MIT"
  head "https://github.com/agentcarousel/agentcarousel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93d5f5a7e7851aa2f2e81f74edf171b03471c9efbbbde6f9ea29da3f70faea94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d17a5bf9d071ba107948c177a7a206aa6001fc60bc6e0b16a5c179922e956d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1008643547e3f1b2f22d3459bbeafd89312e8c98686ebd261da73e2f620b35cf"
    sha256 cellar: :any,                 arm64_linux:   "c3190f530aa8241aa05a65fd99786144f59b8f44b5596bcef0b9e045b567c9a3"
    sha256 cellar: :any,                 x86_64_linux:  "091027a85c89ee73ee9406d3761377ef2ee9eabc4b536b4486c5ec07af37fcfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentcarousel")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agc --version")

    output = shell_output("#{bin}/agc validate 2>&1")
    assert_match(/fixture|found|valid/i, output)
  end
end
