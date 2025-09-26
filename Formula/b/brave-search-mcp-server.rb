class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.19.tgz"
  sha256 "da286c7899937951f8f544b7bed29ac2322abcefcc18dbfacbd6c0d90f3b7a1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb88d27051b1e9c97c9d67b2a4e5b13a1d7e445ad322658dbc8f202f6d52fc29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691d733dc661b085599d9444a12bc84c8777b1f53b738d26b3eaa2e105da02c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f664412c7604b4da6aed08d65c4adcc37de3281fdccff819ec2cc8771bbf9c3d"
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
