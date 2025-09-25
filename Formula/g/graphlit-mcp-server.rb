class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250925001.tgz"
  sha256 "1acc3ae0ec83d9f6fa3c4672727f6c7b1eb81ab7f38c610190cf0b70bf55a4f9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8d1009e8c9ff77eb7f726552c924d5cc6c06c26c70e767051d9cb7502bb119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387e49271488e4f9ae9777281767faaf3b6a3f9205f981b60e60fc64415be3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b79196a80daaffcb2976ea149366efc9cf2d452b088296413b8b7d318a069b1d"
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
