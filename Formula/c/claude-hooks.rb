class ClaudeHooks < Formula
  desc "Hook system for Claude Code"
  homepage "https://github.com/johnlindquist/claude-hooks"
  url "https://registry.npmjs.org/claude-hooks/-/claude-hooks-2.4.0.tgz"
  sha256 "b55f6dbdec8ec51f26f459bf2888ae9cd6deae1a1e3ac992904080e118b6e80b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-hooks --version")

    output = shell_output("#{bin}/claude-hooks init 2>&1", 1)
    assert_match "Claude Hooks Setup", output
  end
end
