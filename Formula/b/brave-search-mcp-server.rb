class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.15.tgz"
  sha256 "ca2e09ca2a2f620b1825b67a82e7db4b798cacdda02eafdd0e98dcfd293abf82"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730fb1b1623ce1034d7467ac337e22e02db29e890f97d209204066bb4dc4fdaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c41df4519aec7a6ff5d245dd0a4e3f1a10629cca8920db5d630a0beac23b96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8445312e807a3c1a35dc2c7b7e6165393991b5346193d0c918e97eaa9abec7c"
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
