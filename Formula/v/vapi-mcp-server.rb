class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.1.0.tgz"
  sha256 "a7264d68b56daf3e56316a85248f8c86e0ccd16acb170fd7d630ec17595ca25a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "347ca9e634d4b88550cdd3fff05122c1cd9a847246b51f48f32538b3ca614d26"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
