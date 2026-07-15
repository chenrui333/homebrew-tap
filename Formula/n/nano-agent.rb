class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f2fe0bd3cebe4a954384783dc4563af423145531e3351dca190d1311191f2354"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a7c4cfffc28e6f149c96809d5a2125faa4be893ebce9cf16ae3b3fe3e39e096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e246da438849799900e4108f658b1712fd94dfd4eccd4e36a213741ddefe5c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d6144bc5ab55ab4094650f636b49c737636d360aff2e6c73d4e6481cce3fbf"
    sha256 cellar: :any,                 arm64_linux:   "177191e89a51ec5b5c0c36732502551b44525c0afaab5d430a4203c97848981c"
    sha256 cellar: :any,                 x86_64_linux:  "1fe43794e842c0efde839469826bd5deeb53988f4e86c54a16d6047f4b63e44a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/nano-agent --version 2>&1", 1)
    assert_match "OPENAI_API_KEY", output

    output = shell_output("OPENAI_API_KEY=test NANO_SANDBOX=off #{bin}/nano-agent '!! printf nano-agent-functional'")
    assert_match "nano-agent-functional", output
  end
end
