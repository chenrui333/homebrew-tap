class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250930001.tgz"
  sha256 "948b03ede5d61e0bb20da94f50a5954e33bbb8f3d65e98cd08e3f4015417514e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a63276fa13be47397d3a64ef0c26022ca5ffc6b1366dfba5880b51efb61544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ace8cf830755c6b1e19d61a022babe0c92439a15b9770b76a89f34c7055325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c66f3f5abe59a4bc7abd07f10cf37d929fe8f190f7076c104f0ad650638b57"
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
