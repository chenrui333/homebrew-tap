class McpReasoner < Formula
  desc "MCP server for beam search and thought evaluation"
  homepage "https://github.com/Jacck/mcp-reasoner"
  url "https://registry.npmjs.org/@mseep/mcp-reasoner/-/mcp-reasoner-2.0.0.tgz"
  sha256 "cf03037abee12121e720fa38bf04983d3729c1f01af525a555aba3c21fa86084"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
