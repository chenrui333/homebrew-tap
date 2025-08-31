class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250830001.tgz"
  sha256 "b41c4d1577653fd05b74e4a2c1335c28e2e29749a5774422870f74d2a28f1f53"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59473166a8830a686cedd73b3efcc36a01b9a04d02d99024258d7030cce78af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "266c9c51b3aea3bc0d5387bec65c4c7d15ec2d6dfee83d6473fd4fcb40029bc8"
    sha256 cellar: :any_skip_relocation, ventura:       "31a24ec0006d302613d5cfed53a3c1e9f36cddbf3cf8273f19635d74b5a6ed9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af154022b5d4e5cc556841c53f33e280a3dd28b40f36c40420ada701c012947"
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
