class AppleHealthMcpServer < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.0.1.tgz"
  sha256 "998cfedb34d1e3240f0408459e91e01fef5b28953b71889d6159772e0b385c30"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/apple-health-mcp" => "apple-health-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/apple-health-mcp-server 2>&1", json, 1)
    assert_empty output
  end
end
