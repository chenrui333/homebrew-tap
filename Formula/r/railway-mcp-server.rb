class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.7.tgz"
  sha256 "63b8745784839d973180da24595c8f99e81dd6d8c1415f612ebf28c3b6addadf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45fb7243d32b4cd94e60ffdbee683d35bb17cf40573284f5f1822cd335820172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9830fe63d8a638a840767c721525a0838d76c6949a5d24176ca9c49128523b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b583715d2b570a9089c972de3cf3ca7cffce0c6d3b7cb4ce07fc6e5a0ad6c3"
  end

  depends_on "node"
  depends_on "railway"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"railway-mcp-server", json, 0)
    assert_match "Check Railway CLI Status", output
  end
end
