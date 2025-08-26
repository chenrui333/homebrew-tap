class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.9.3.tgz"
  sha256 "92f4c8d3b91b21cbb2115219b2eb9d7e0f64c9277b0fa880bb898b33cdcea86f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30a30a5b24303dd2ab54171ef930e737ae0b49901952e1f4b31951afd9e5c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daff090eb7bb07e4f1acf029943cf12af4433cf6597d37c375bedbfeb127fadc"
    sha256 cellar: :any_skip_relocation, ventura:       "6582808a6aba30fe02b79cc089cd213b7a442d06f6b1a1123b85f3772ad097c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c49341356deb8aa01482f6f8c69e0caa2fb0e9ddc9f697356aced76891f64e"
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
