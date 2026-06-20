class SwaggerMcpServer < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/gulbaki/swagger-mcp-server"
  url "https://registry.npmjs.org/swagger-mcp-server/-/swagger-mcp-server-1.0.3.tgz"
  sha256 "dffa5d9e6b5982251b90ee049d48fc9ef1e8aee4be2c8b389566e7aac7ede51f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f8abc63553a154d7b35c639ec44f3f9a22b0a5b3ec96fc112c84c381396557b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "No config file provided", pipe_output("#{bin}/swagger-mcp-server 2>&1", json, 1)
  end
end
