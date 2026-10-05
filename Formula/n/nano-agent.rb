class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f2fe0bd3cebe4a954384783dc4563af423145531e3351dca190d1311191f2354"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09449607aa0575d11471839e78a9c9c4640098abb49654eec90c67b9f783bfb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee7ffa14af81c1130131374f79580c732ad1470b359278b49ac1b1792b9b668"
    sha256 cellar: :any,                 arm64_linux:   "a7406754f85878cc58a860d02849adf7d58ff0918cd763b4c0db58660a1e2e7e"
    sha256 cellar: :any,                 x86_64_linux:  "a0df684ae96931756b486fec3f0ed45728419752dbbb0b1edc2c3aa7acac474c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
