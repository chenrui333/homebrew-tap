class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.1.tgz"
  sha256 "b90cbe37b2265e36a9ab70fd0f1808b6f83136a71cb1f07f34351740dd949dc4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa83dbfc0b705bb5e082a0b8b4a80f8a1cdbf53230a769ee509f78bac258ce1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6a3b0dae4c291eb3c87fcb60013e0c24f9d1f32cd87ccb8b62a509cad127e0"
    sha256 cellar: :any_skip_relocation, ventura:       "7f3b7663d528b5e17fd56500f9114f2248d887dfc99b47b0b85780536434752e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba39b6d97530faf7c53abd838d62710be9e6c7c7169e4d82fd356f3fa5d2ad1"
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
