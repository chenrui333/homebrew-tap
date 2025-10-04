class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.25.tgz"
  sha256 "67fe0e0f2a068ede9c4d2b13bc5b7294f008acfb8647d9d8a1d84ad16ef99a63"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ea09197f8fd70d45a7f3e42c3ad215b7cc5dc71556d5b3a59880f8083b94850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84db8c9a68bb39460ae4c15f3fb67bb62a2d1f3ce928b2510be1d98e1de973a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edd1d7cedcfcff7648d6d7d61daf86520c135e16b5ce9c86219f49e0939b69d"
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
