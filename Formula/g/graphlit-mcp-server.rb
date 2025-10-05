class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20251005001.tgz"
  sha256 "b890a14ea173e4dc682ba95e21071d2780952cdb716a13ebfa507c60a6adeb43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3add48537fc840a4d0e989939c0912dbbaf4d9f58507e4b70cd1478b814ac12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5ba678f0f89ecb8fcdd94e9d1f1fea0790716ae832b64f95109233eeb3af94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee4a230a98fe2f7e76c92f9cdb61a45b2dd0d7c167aa349e76fe913e4aa7994"
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
