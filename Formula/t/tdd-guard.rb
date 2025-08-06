class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.8.1.tgz"
  sha256 "bdf335d0f33b17fc220a8885d4928778e9a937f19ca313f9b4c76903fbcef096"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a5a45907399b161bc6401aa9d4810bd90db75a54ae49ba2a6dda719216ee271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4b6c4a1da321f9c29b105838024496adb4f28b317c5f1e495a01b961712377c"
    sha256 cellar: :any_skip_relocation, ventura:       "1138e138e987255444d15d80a3c3ed0ca0109b4f27fd1022ab82e2d1d1385dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907f3a4c092f993457df1f8c3f6dfcdc94bd20254101c08944d1b2e0c4eafbcd"
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
