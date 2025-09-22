class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250921001.tgz"
  sha256 "0044c9965cc312174e170c8ee3dbda205b282ee04e4d5f2ebf8c0c5046f87afb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64fc056826dc1b45188c281684d1b81ce958560bea82eee29f2a9626b631f184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66a2322d4fa0c68b11b63d9dfd860600ee001100dd3f5a5214f13d652c28f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9250c3c883f75c41f9d0576b12fc390ffd95baff8646fcbf211508b2bcf73758"
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
