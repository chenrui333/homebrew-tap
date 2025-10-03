class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20251002001.tgz"
  sha256 "2661968fcf4390b1aef522ab9315aafecb2f103a9791751961edf8f30f9d3aa1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d334823edaadf325b88ee351b39055864aa4e11c98f8cdd41dcdc2f9c9d21c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4246b0725664a7c328e0ce1374c72ede0f3750647ef1b969bc7587975029b1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465f259dacdf610680f76cd1325f96f1d44895f93ed0f4a47a37f246e2ef23c1"
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
