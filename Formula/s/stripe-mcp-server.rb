class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.3.3.tgz"
  sha256 "2478a32e0d4e6a2c30dde7d04d36f6a6cecaa5750b1432f147aa891b785cab96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5d6e897667757b80d65c1240527e8949771b4f1b1a733d0b6672c26e5c9e65af"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/mcp" => "stripe-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    ENV.delete("STRIPE_SECRET_KEY")

    output = pipe_output("#{bin}/stripe-mcp-server --api-key=sk_TEST 2>&1", json, 0)
    assert_match "Stripe MCP Server running on stdio", output

    output = shell_output("#{bin}/stripe-mcp-server 2>&1", 1)
    assert_match "Stripe API key not provided", output

    output = shell_output("#{bin}/stripe-mcp-server --api-key=not-a-key 2>&1", 1)
    assert_match "Invalid API key format", output
  end
end
