class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f2fe0bd3cebe4a954384783dc4563af423145531e3351dca190d1311191f2354"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514d4301adc5d8c39bc1b9ec218cd288e1e1c8f3284342a7ed9ec3c0042a43e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d7dbc8a2f71f60e8e01db191f641b92339df38055d35ff7ecfbff1553284e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c616a0eeb997a20611bfcee43913102326340aca0faa067c459a0aa024fe64b8"
    sha256 cellar: :any,                 arm64_linux:   "d58ac234698c08d650ccfe540ee1a016fed281a8662a9b739ab41f2d6c8367ea"
    sha256 cellar: :any,                 x86_64_linux:  "6ed077f31309e167f7f8eef7643de87d45e6f44d6e04cc1e1f5fbb7eb0fd3907"
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
