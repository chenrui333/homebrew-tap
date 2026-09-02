class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.8.0.tgz"
  sha256 "154eadbb0b2d59e6883d658d228eba1e9e134491f09e55d4230d9f927209dca0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "640d8959d19f7610542cc4fae1370c806add51d196889cbf95164541aa592038"
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
