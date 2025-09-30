class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250930001.tgz"
  sha256 "948b03ede5d61e0bb20da94f50a5954e33bbb8f3d65e98cd08e3f4015417514e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab59d2a4282146a5bc4b9176c9962ebaefe2a3ca13a136b142ebc2e150d86398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82cd9968fac71248f0f1b276e7287f9b96404d6005e6c28524823a7e15d57993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460bc339e6f37dd59c023857081104df4c7b3e786d1fba506bf4664b2ffbdc7f"
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
