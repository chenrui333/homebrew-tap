class ClaudeContextMcp < Formula
  desc "Code search MCP for Claude Code"
  homepage "https://github.com/zilliztech/claude-context/tree/master/docs"
  url "https://registry.npmjs.org/@zilliz/claude-context-mcp/-/claude-context-mcp-0.1.3.tgz"
  sha256 "89aabfba81877cb73d571bbe6b4ad396c43f4a259f0803875e9b03fe2afdc64a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
