class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.2.4.tgz"
  sha256 "49af58e19e6c0a25d823036346c2ea47e0676fd00d20ad6d0f22f0f1631e50b9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp" => "stripe-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/stripe-mcp-server --tools=all --api-key=sk_TEST", json, 0)
    assert_match "This tool will create a customer in Stripe", output
  end
end
