class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.3.tgz"
  sha256 "25a59558c0ea150e0ee0732774a73cbac62297c8a952498725a922f8a099a5ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9dca38fef3935e03e4722dbedd64af0d3de447cb4611eaae0625385948988c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93800bec575e622301010545c97d27aa7903b02b1cc25423de812a4f1f05af31"
    sha256 cellar: :any_skip_relocation, ventura:       "84504560e25a8c2b533275626e962a4d891c96b166ae4e9ba667f39effd914c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c87b49eec207697494792f3b0029d3edc80240916bbba0c72fe20c90020730"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["APIFY_TOKEN"] = "test_token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/actors-mcp-server 2>&1", json, 1)
    assert_match "User was not found or authentication token is not valid", output
  end
end
