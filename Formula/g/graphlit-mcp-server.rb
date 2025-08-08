class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250808001.tgz"
  sha256 "f408ba4159ad5b783672c4542edb96c6af6d4643dceb29c0429c72b2ae9ede3f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057ad0da2849367a45a39fc3037bcb03941d02a0a69a69e3bade47ac8349c55c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bdde3da9c6190da8e5748d6c05e32832cb174c45a6b7f1b9cb78cb1cdf2e91"
    sha256 cellar: :any_skip_relocation, ventura:       "ae57408274022825b6e24ac4ecfa9c09c74696cb33dea06aaf35a00158b52187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2516aec5d1c95d4ddc750574a791d213363c690d402ffc4aa938f084ab08e1"
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
