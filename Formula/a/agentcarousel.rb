class Agentcarousel < Formula
  desc "Unit tests for AI agents with LLM judge scoring and signed evidence"
  homepage "https://github.com/agentcarousel/agentcarousel"
  url "https://github.com/agentcarousel/agentcarousel/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c668a8a43b17fb1de66629ccfab53bd08a0ded1e960c25a74be10d4d4bf14da5"
  license "MIT"
  head "https://github.com/agentcarousel/agentcarousel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50bd15455ad49fa744c41271cd274e3fb662d32f8ebcb044cb9e9f9dd3ef90f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098f8d098dae279182e2f9649b68d9994599e9962dd6960986c6374f5d584be5"
    sha256 cellar: :any,                 arm64_linux:   "b20ae456c953fb41f28c6fb9e9095945bd1d9d14187be25f084abfe2af107f5b"
    sha256 cellar: :any,                 x86_64_linux:  "ef927ccdaab538fd918f269b33e24b11ec01f8155f1ff06d391b5a6bc09a436e"
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
