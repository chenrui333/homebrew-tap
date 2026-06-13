class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4279e871b83e1852ecb132488f5f46ebbd45c4da4eed01f2a0f605400ce31953"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feaf758ebbd5796195b478336654d888545d38803cccf554cd9cf55c23095980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece016f7064a47097b7de1fa3d0405d6ac84079fdcb00f02341b786c1eb2aa3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056a9d5d706666b50e64c5fac5278d03fc4c7043302e4e1e21b2cc58146e0372"
    sha256 cellar: :any,                 arm64_linux:   "6cb7eb1f4f6bc11f563d619fde38a93761ee6531ee3cc1a4efe8ad8c1d0b348b"
    sha256 cellar: :any,                 x86_64_linux:  "cbaca23124b5e69122352c432f2422888699e4384a74cdccdc9375b5c48f687a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/nano-agent --version 2>&1", 1)
    assert_match "OPENAI_API_KEY", output
  end
end
