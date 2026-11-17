class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.2.0.tgz"
  sha256 "8352bc9e119e111346d469f2cb688f1cb229e9f840022cc6f82ec6b29a638224"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d7d52616c371b70c91fab76dda7559fe15a5ef67c575aacb08285296468bb679"
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
