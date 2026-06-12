class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4279e871b83e1852ecb132488f5f46ebbd45c4da4eed01f2a0f605400ce31953"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nano-agent --version 2>&1", 1)
    assert_match "OPENAI_API_KEY", output

    output = shell_output("#{bin}/nano-agent --help 2>&1", 1)
    assert_match "config.json", output
  end
end
