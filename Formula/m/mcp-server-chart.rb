class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.8.3.tgz"
  sha256 "c39dde8ac6244b27ec68fd8d7108b8c9b50ccef3c3e69890b954e3d346aaae6a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1906fe9a58638e17e07971162f3805ceb121dddd953c0c082fe42763eb534735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c85afa79b7fb848344c2ea80bd5d1fe2003bec360a0682bb6611e69fa4ff9b"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f0e58500040692b57cdda94e8bcf284b7664d4727a6f56696490d366c007e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba52d602b6d9f9904b267d19f57f7ee875b374385d066017a3b900e58870c2de"
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

    output = pipe_output("#{bin}/mcp-server-chart 2>&1", json, 0)
    assert_match "Background color of the chart, such as, '#fff'", output
  end
end
