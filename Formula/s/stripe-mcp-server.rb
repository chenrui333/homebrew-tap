class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://docs.stripe.com/mcp"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.3.4.tgz"
  sha256 "6d2915f47f8b6e6c7b536971ffe014d9c8763a6758b35e8fa695f90e25782d1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4ec80441fb9bfacbde270560898a5cf887a54eb8797f2277e3780e225e23ada8"
  end

  deprecate! date: "2026-11-09", because: :unmaintained

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
