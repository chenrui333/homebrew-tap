class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250827001.tgz"
  sha256 "68d6402be499f9a78893843d9a24a3c7803552c85b814f9a602c85ce2758c74f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41adacd8add918b1f68433590af9cbe387b0286c992d476971bd1e888f26f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091b64e4893d1c326fb8c79d809f3738d8a6098c6712822e26e19dfd364421e1"
    sha256 cellar: :any_skip_relocation, ventura:       "c700f2b356ea90af1fcb6655be8b26be6fb97ad354caa1caf42854164092d482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90cb30f36badc3ba7f560ea815fa5935b0219745385f9859f5f0b614858ff93d"
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
