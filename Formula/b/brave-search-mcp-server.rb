class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.32.tgz"
  sha256 "69d52f184b82193b003ac2e3404507666424b914672f53176a2c0f5e0c77a68c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6588a4d4b22d27305de18f1b528768f8cee53664e72e41081cf1e30416248ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05fa2b7d23cd5a3182b26111f17b2bee709dcd18e4785502bffdb4cdc3581a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5832e5f104d3182c2067fec40ccfd5296c76ab81c3ec7fdb9bafc136f4307fe"
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
