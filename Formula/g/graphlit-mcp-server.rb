class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20250830001.tgz"
  sha256 "b41c4d1577653fd05b74e4a2c1335c28e2e29749a5774422870f74d2a28f1f53"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d13cb0b37a9851501606bd17ae5d2347905851b4b221158fdf503b943b71134a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0538d5e86dd81de5ba69f3a877b4a1735729a86c35170c0b9b2923ce9ba28980"
    sha256 cellar: :any_skip_relocation, ventura:       "39dc7062b71657ab80e568860ca1109843f573413403a7cac1696f549f9e7272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab4e48863e93f7250fccc1f5a934ae9e25e8e591989baa35d4ef38830dec067"
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
