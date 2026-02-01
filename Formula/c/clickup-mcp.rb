class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.6.1.tgz"
  sha256 "1a330c5c01babc132073addc76f468a3568bd7df4c6afba3d80f288e38d6c98b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ba380495454cb3bd0eca91547f9407bcfc6c828c8e54b81bf221dd75f1c7f58f"
  end

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
