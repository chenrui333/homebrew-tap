class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20251007001.tgz"
  sha256 "06c51ba0bcbc56c0afe33744a51e423a75d4c7d37acdf51588748f46ff434f27"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce4f9c249fed851ad21940e6fb36603e41ecc84e046175e6ae33c8a53aeb367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fa5d772f1f13af5872c64d07f76d41ec7138390ba2ea2775c6044fe566d22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db0e4cf139002210f177370af6fb3368bd8dcc9195ebd80ffa9130c5c098c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9c394562a3d1b104f79dea1cf4309fa9912acf8365418836ed3e31b3b50528"
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
