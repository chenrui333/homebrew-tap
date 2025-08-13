class StripeMcp < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.2.4.tgz"
  sha256 "49af58e19e6c0a25d823036346c2ea47e0676fd00d20ad6d0f22f0f1631e50b9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fee7f6ed9b92370087d9cd1d5f9aa49c4b2f17cc86535b23d91cd7dbaf1a3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49b59aa77d12d49f591a9e4c27b9d9c91a41b81d88feb30369b91e96e8d44923"
    sha256 cellar: :any_skip_relocation, ventura:       "aeea1ce4658172e29138b62abab11984d5a974df64c69d1d26bcb3b4d93948cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0a67506c5472b8c50745105d747ad00db7122ac0184ddc2611e1cf533e81f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"mcp", bin/"stripe-mcp"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/stripe-mcp --tools=all --api-key=sk_TEST", json, 0)
    assert_match "This tool will create a customer in Stripe", output
  end
end
