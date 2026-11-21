class Agentcarousel < Formula
  desc "Unit tests for AI agents with LLM judge scoring and signed evidence"
  homepage "https://github.com/agentcarousel/agentcarousel"
  url "https://github.com/agentcarousel/agentcarousel/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "032a6c178f6f395a92d81f0acefd26022f5a2776a3cb0020b615e5434fec7f1d"
  license "MIT"
  head "https://github.com/agentcarousel/agentcarousel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e36bdd4c79063d9682a17a982f349350599dcefb5ad1b552db01d90a6d65bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b19c07fbb86cf1675be40db054d2fb9041c75656b3aea05e6ac740b7e051c7"
    sha256 cellar: :any,                 arm64_linux:   "d393ee6e4b82a4f825bd0b0f840a235d0a6415a609774e7fb3bfdc04220150eb"
    sha256 cellar: :any,                 x86_64_linux:  "ea28158b6e576dc2af99be4a7860987d8ea1f9a749eb898d5d2dac6ca50a95cf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "crates/agentcarousel" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentcarousel")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agc --version")

    output = shell_output("#{bin}/agc validate 2>&1")
    assert_match(/fixture|found|valid/i, output)
  end
end
