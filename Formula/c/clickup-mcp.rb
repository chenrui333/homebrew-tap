class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.5.1.tgz"
  sha256 "6f9023e9983ee7dd4bb120ebd20ef8476fbe4a16dbc79f58dc84e31d4005e16b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["CLICKUP_API_KEY"] = "your_api_key"
    ENV["CLICKUP_TEAM_ID"] = "your_team_id"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/clickup-mcp 2>&1", json, 0)
    assert_match "Error fetching user info: 401 Unauthorized", output
  end
end
