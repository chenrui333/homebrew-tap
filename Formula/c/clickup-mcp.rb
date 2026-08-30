class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.7.2.tgz"
  sha256 "28d5cfd8efa9df96908b8250797b5748775ff5653c05685a6b2d41426004bc07"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1917a3a2b43b4726122641fc3a0d632ddb969314ae545ee3a79ea899c9e3b7c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["CLICKUP_API_KEY"] = "your_api_key"
    ENV["CLICKUP_TEAM_ID"] = "your_team_id"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/clickup-mcp 2>&1", json, 0)
    assert_match "Error fetching user info: 401", output
  end
end
