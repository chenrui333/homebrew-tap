class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.0.tgz"
  sha256 "fce8f5edc722e7e78da36237fddd0226c37ff4a8a778a84d26d9b0a51a47943d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79595e023484dbc7032ebb17124d68fa3013cd9fda53e6a62fb6ce04aa3051d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e900ea05c3d8abb6228d50a050bc72b116460cc807ee8319ebb51c5e0a2a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202f5109d435bd6d24460694114e0afffec0c6d0bd451bfabe58d68b73219bca"
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
