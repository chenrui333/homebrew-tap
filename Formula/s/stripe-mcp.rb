class StripeMcp < Formula
  desc "MCP server for Stripe"
  homepage "https://github.com/stripe/agent-toolkit/tree/main/modelcontextprotocol"
  url "https://registry.npmjs.org/@stripe/mcp/-/mcp-0.2.4.tgz"
  sha256 "49af58e19e6c0a25d823036346c2ea47e0676fd00d20ad6d0f22f0f1631e50b9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0fb167cd0e2516cdd805cff1c383874cb3a7f5d31f4fb571b88230dc7053eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad3f92d70a9183c577abb2c3a2d03ade04c0dedc7e920909187a91e6282e0b6"
    sha256 cellar: :any_skip_relocation, ventura:       "0d03b0f0022a4aaa9ed14a0677dab5e4497830a458ed04e329239ac9ec70c1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854f04de97b2c494b847f2d6162e530d948425ccfe86ed861c1a5bd37f5f140c"
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
