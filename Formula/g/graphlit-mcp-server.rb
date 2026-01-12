class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20260112001.tgz"
  sha256 "b95527f3243cb910c7b4c65b6b76ad49d4d617df1dcace6416985fe83a98ce22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "30bf49f1d1daf11b5d9d2d5dea5c6f6a773d66ebe45be3104fd677353e62a786"
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

    output = pipe_output(bin/"graphlit-mcp-server", json, 0)
    assert_match "Prompts an LLM conversation about your entire Graphlit knowledge base", output
  end
end
