class McpServerTester < Formula
  desc "CLI-based tester for verifying that MCP servers"
  homepage "https://github.com/steviec/mcp-server-tester"
  url "https://registry.npmjs.org/mcp-server-tester/-/mcp-server-tester-1.4.0.tgz"
  sha256 "ac195741b7eccbaeaf23590c401b548024c6beb95bf1c3ccf0d5c1dec1e45786"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-tester --version")
    output = shell_output("#{bin}/mcp-server-tester schema")
    assert_match "Schema for MCP unified test configuration files", output

    output = shell_output("#{bin}/mcp-server-tester documentation")
    assert_match "The MCP Server Tester is a tool for automated testing of MCP servers", output
  end
end
