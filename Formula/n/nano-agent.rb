class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "88f1bb9f3dee180807f65d10167e35eb3f0eb0e93e6189bda341e5434e601407"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00074beee2d10ad3ddf14729b9fdf7a9f6db18dda89fa16e8da077baa3bc2e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1419a21578207d6ebf26ad1f05f3d21d045a299e9385475f2375f92c41d8d074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de80c25ba09711e450ab7b29aa17bcb2f330af2dff6476f7a916591130088de"
    sha256 cellar: :any,                 arm64_linux:   "ea53f901339b336152bf63863dc4325dfe3adc055d8c46c77709dd455eac7cd3"
    sha256 cellar: :any,                 x86_64_linux:  "7052497e5e3851def99a30dd65412418cae2ea5ad3373f44e21cd1c432669317"
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
