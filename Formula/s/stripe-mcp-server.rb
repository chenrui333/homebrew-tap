class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.2.4.tgz"
  sha256 "49af58e19e6c0a25d823036346c2ea47e0676fd00d20ad6d0f22f0f1631e50b9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c198731668c2b540020c1a7675ba65fe86f360ccde5ca78d0479584d239510e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e86bb1e1e72225c8a4a14ec6c8dce708463cd185a79a926eebdb5cd8beb9a9"
    sha256 cellar: :any_skip_relocation, ventura:       "ab50b3cb860176c679e21f2dcaa33e3b33ee4fec79ea7d81ee5e2923ee0756e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1f0b2b5819d4dfbbc7aa4bfe9f172af87d6d85eadb03a3c77f97f69fcb295d"
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

    output = pipe_output("#{bin}/stripe-mcp-server --tools=all --api-key=sk_TEST", json, 0)
    assert_match "This tool will create a customer in Stripe", output
  end
end
