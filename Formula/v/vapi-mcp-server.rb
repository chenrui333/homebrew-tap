class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.0.11.tgz"
  sha256 "90e98107d5a6315df4cda64537d30d952862c00564d2172c9dcef50e42f2baf8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b499fae004902b9ee62883ccc5ef053d2888a61d0d348948be0eef4da0515d05"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server" => "vapi-mcp-server"
  end

  test do
    ENV["VAPI_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/vapi-mcp-server 2>&1", json, 0)
    assert_match "Lists all Vapi assistants", output
  end
end
