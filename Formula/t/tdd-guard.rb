class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.9.2.tgz"
  sha256 "a40a1b304b00cbd122b3fc780cbad095b6e984d4704da81c577a1253be9ed334"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dbac1ff1c72e72fb8a2b0baa003623d8dae02d9046852edf0724204c64952c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646b84647caf2b40bff11fa73b42ac34e4eacb7a5c48f2775846940b59eb4966"
    sha256 cellar: :any_skip_relocation, ventura:       "0bb4acd9776c070783201e26446a463ade1a1a8ef046fabdf29ea9f258596123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2820fe289cd399419bac90c4d260a621aa33210fc4fe5dd2732dffcc334fc0f0"
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
