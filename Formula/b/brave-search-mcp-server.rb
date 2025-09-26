class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.24.tgz"
  sha256 "989252276d287a07fefc3b262a853ecaa1b0febcb27d83e267a2142d3185ac2a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2dffc87053714aa598fa77920bdc735a2cae8a81f8a9d529062caf5abd2ab2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc86ef55d11c983735beda3c65669dd6e414b37d2a0d2a1b11d7a578f26dc535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e8812270d8210c5fde8a9436505a993bde38e7e8eb58ccbe8eb7be63a28643c"
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
