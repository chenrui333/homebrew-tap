class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.9.3.tgz"
  sha256 "92f4c8d3b91b21cbb2115219b2eb9d7e0f64c9277b0fa880bb898b33cdcea86f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3299409f7488cc12d4bd0e0ba6c6d69bc6fd6bf86dbc62ccc2b11c5f95a441d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da1b4e0a4b2b747638a2b64d5b5394012861d13f958a5a11f730f51063c3dcb"
    sha256 cellar: :any_skip_relocation, ventura:       "c97f18f43fe0fce28bfe5fab4eb1650634ef539fc4ce7fef091281557d690d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5277b3a7c1b2f63266962aa26634466fbe4232363925d2e203f83b17a7048e28"
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
