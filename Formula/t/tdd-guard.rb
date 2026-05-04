class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.1.0.tgz"
  sha256 "f9da65d258979704097f6646190473a31080e05909ab54c814b8d902a8938087"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e6819975f8e39b0c55e8374d02f464492daa0feedc97f70d23e65a47f0ebc5e3"
    sha256 cellar: :any,                 arm64_sequoia: "ee0e0e55bd08ef48a097875f8155c4bbef36f76b5bb65ecc2252ec8618ccac64"
    sha256 cellar: :any,                 arm64_sonoma:  "ee0e0e55bd08ef48a097875f8155c4bbef36f76b5bb65ecc2252ec8618ccac64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1934a40ca684bbb527e73814bef355e6e85b404bac6719f9fb2726491f32fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4387aced381ebee74c9430eab942c78f696801c20e0a52756b3e9b18f731c5d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
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
