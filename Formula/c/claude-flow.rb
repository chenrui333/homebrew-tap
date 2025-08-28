class ClaudeFlow < Formula
  desc "Safety layer for your coding agent"
  homepage "https://github.com/ruvnet/claude-flow"
  url "https://registry.npmjs.org/claude-flow/-/claude-flow-2.0.0-alpha.86.tgz"
  sha256 "653bfc4a6c10650e72c8329a7a4413f5c7361c3e94cd666d60ec2e860d6e865e"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-flow --version")

    system bin/"claude-flow", "init"
    assert_path_exists testpath/".mcp.json"
    assert_path_exists testpath/"claude-flow.config.json"

    assert_match "10", shell_output("#{bin}/claude-flow config get performance.maxAgents")
  end
end
