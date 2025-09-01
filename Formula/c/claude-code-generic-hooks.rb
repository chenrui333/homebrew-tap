class ClaudeCodeGenericHooks < Formula
  desc "Generic hooks for Claude Code"
  homepage "https://github.com/possibilities/claude-code-generic-hooks"
  url "https://registry.npmjs.org/claude-code-generic-hooks/-/claude-code-generic-hooks-0.1.13.tgz"
  sha256 "f0b9d95daab6c4be59fdfb6ff55ede58cd816f07e22ca0e8e8d5ae152341bec6"
  license "MIT"

  depends_on "node"

  def install
    # patch version
    inreplace "dist/cli.js", "0.1.12", version.to_s

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-code-generic-hooks --version")

    output = shell_output("#{bin}/claude-code-generic-hooks activity 2>&1", 1)
    assert_match "Track activity start and stop events", output
  end
end
