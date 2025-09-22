class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250921001.tgz"
  sha256 "0044c9965cc312174e170c8ee3dbda205b282ee04e4d5f2ebf8c0c5046f87afb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3a5cf29f1a97a9e9706060af2da97e1f61015105c50c3635b28a619dbfb65c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3469c77cb7d41df274453d02600a9888f8435dcf67b5221c45d65083676dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1450096e9c6f0c25a884cbbaae9bb92af61c4d6ab7c9f824ab944f526f8c066e"
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
