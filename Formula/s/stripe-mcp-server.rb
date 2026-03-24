class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.3.3.tgz"
  sha256 "2478a32e0d4e6a2c30dde7d04d36f6a6cecaa5750b1432f147aa891b785cab96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1d71f551892ce2f058552a5202e72ec6ef8b33fdd2ea2642140e14bfc3f7f6f8"
  end

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

    output = pipe_output("#{bin}/stripe-mcp-server --api-key=sk_TEST 2>&1", json, 0)
    assert_match "Stripe MCP Server running on stdio", output
    assert_match "Unauthorized. See https://docs.stripe.com/mcp", output
  end
end
