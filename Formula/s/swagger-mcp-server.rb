class SwaggerMcpServer < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/gulbaki/swagger-mcp-server"
  url "https://registry.npmjs.org/swagger-mcp-server/-/swagger-mcp-server-1.0.1.tgz"
  sha256 "c5f8f3b8288a9823fc26c3d3a8a4806ea48f3260b9da9e7c705a902064cf4265"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "No config file provided", pipe_output("#{bin}/swagger-mcp-server 2>&1", json, 1)
  end
end
