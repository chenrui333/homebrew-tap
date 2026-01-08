class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20260107001.tgz"
  sha256 "a7de00b9439464a63a8549172116b04a4dc1f00580e4d7e1cc24e2038b9cff1b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a73ca40032909025116af2ab5061ee3183d1a46e599f5fa0b4761d854c45bf12"
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
