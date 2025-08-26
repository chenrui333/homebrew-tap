class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.0.9.tgz"
  sha256 "878ebf343c19b735bddefef7e27c6402b6e9291fb2c1351d8a4072697082a5e1"
  license "MIT"

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
