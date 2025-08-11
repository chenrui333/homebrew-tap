class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.9.1.tgz"
  sha256 "2fa125d93688abf70050aa11af717c3e9ee62c2c14569088cb97dd37e1ab3e64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2e23c52df1e4582ab4d1d59a59c0301f439b57e82726c89db46faba8b555c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57f01541b64e63507b8499c5030ae747900e39b6b0286097db014ab432fb83c0"
    sha256 cellar: :any_skip_relocation, ventura:       "cf66dae39d58313d079894d2badc211eec2860bc7c24ceab76b64b86d3fb210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2b52adee3bd939b97a3a9a0b1c87237d029a3b7f8ff6ba339b050112b32b78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".env").write <<~EOS
      MODEL_TYPE=claude_cli
      USE_SYSTEM_CLAUDE=true
      LINTER_TYPE=eslint
    EOS

    input = <<~JSON
      {
        "event": "PreToolUse",
        "tool_use": {
          "name": "Write",
          "input": {
            "path": "example.py",
            "contents": "print('hello')"
          }
        }
      }
    JSON

    assert_match "reason", pipe_output(bin/"tdd-guard", input, 0)
  end
end
