class Agentcarousel < Formula
  desc "Unit tests for AI agents with LLM judge scoring and signed evidence"
  homepage "https://github.com/agentcarousel/agentcarousel"
  url "https://github.com/agentcarousel/agentcarousel/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "032a6c178f6f395a92d81f0acefd26022f5a2776a3cb0020b615e5434fec7f1d"
  license "MIT"
  head "https://github.com/agentcarousel/agentcarousel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3b6c14c7da20c1c0814054801c3614b534b5b7898b5f653865dcb876a42094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ad39d8e74faf6656c707e2d79028c8d4df90df04380dd10ce9ff27f39bbe8f"
    sha256 cellar: :any,                 arm64_linux:   "175b7e6cfb4a15a6f6f9af4f50548c0a55a178999dd4e5aa760e66cc2d76fa2e"
    sha256 cellar: :any,                 x86_64_linux:  "e0446ee5da1bf157cd239629cae6708bc25ecf726eb9bcea1a8d69b187d291cf"
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
