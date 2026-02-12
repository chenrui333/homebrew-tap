class StripeMcpServer < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.3.0.tgz"
  sha256 "f9d099d6f70dcfad0dbb104cdea19a471283f0b9c1e3f15a96f6ef9455513b39"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "64bdb2a74379fecf25aa90cb6fed7e8888a4cb42424223c62a3fc6e55ff74577"
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
