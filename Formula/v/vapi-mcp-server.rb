class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.2.0.tgz"
  sha256 "8352bc9e119e111346d469f2cb688f1cb229e9f840022cc6f82ec6b29a638224"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e54d19305699789d3c6cbb223e4404de77a96b5545e315224fcc4b1cd148cee9"
    sha256 cellar: :any_skip_relocation, all: "1ac726526635748824359c0f86a8c71cba1853ed2826a05c2e1943409ad28789"
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
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized"}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    output = pipe_output("#{bin}/vapi-mcp-server 2>&1", json, 0)
    replies = output.lines.map { |line| JSON.parse(line) }
    initialize_reply = replies.find { |reply| reply["id"] == 1 }
    assert_equal version.to_s, initialize_reply.fetch("result").fetch("serverInfo").fetch("version")

    tools_reply = replies.find { |reply| reply["id"] == 2 }
    assistants = tools_reply.fetch("result").fetch("tools").find { |tool| tool["name"] == "list_assistants" }
    assert_equal "Lists up to 10 Vapi assistants", assistants.fetch("description")
  end
end
