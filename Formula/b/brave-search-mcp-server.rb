class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.18.tgz"
  sha256 "4baa2072e5c80202cf8919f165ca0d9721f3c3e76150700ad6ab8f8e3b5fc638"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e25e96337042b86c4753fcc0a9e69e2b55f6508618e04147907e9c874281ee3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbf32a05e6c1f4cea9dbea8857938eca41838cdec2fa4ed43a119be82bd2b367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a985b0f97f93c6d9ea0d73bf5bf0e252cd0fdede6fee7770b9d12417dc0a9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/brave-search-mcp-server --brave-api-key test --transport stdio 2>&1", json, 0)
    assert_match "Performs web searches using the Brave Search API", output
  end
end
