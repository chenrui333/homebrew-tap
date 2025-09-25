class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250925001.tgz"
  sha256 "1acc3ae0ec83d9f6fa3c4672727f6c7b1eb81ab7f38c610190cf0b70bf55a4f9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359515bb8be9c948c58fec49a8e32f0872b7f78b91f72e7a097367f1748c3dfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae380ca2d589816279985ef8e9b1a398fc74f41f2215e7206e3bb6db33d06cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9e0a002f747e62acef27d48fef0ca90075fcd2011b9276c2513d24532148fa"
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
