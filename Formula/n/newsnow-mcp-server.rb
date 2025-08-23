class NewsnowMcpServer < Formula
  desc "MCP server for NewsNow"
  homepage "https://github.com/ourongxing/newsnow-mcp-server"
  url "https://registry.npmjs.org/newsnow-mcp-server/-/newsnow-mcp-server-0.0.10.tgz"
  sha256 "b35f06401bba08bdf359db390c21053d8c2e1497bdaaae9c8ced908d8e9a0301"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["BASE_URL"] = "https://newsnow.busiyi.world"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "get hottest or latest news from source", pipe_output(bin/"newsnow-mcp-server", json, 0)
  end
end
