class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.7.tgz"
  sha256 "63b8745784839d973180da24595c8f99e81dd6d8c1415f612ebf28c3b6addadf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30d312bc15d760e5f779129c830bca7b9339d6043de7b7f1273890ac228c489b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296d1fd72a5478460fa0e932456652a4e365d6895074c25f216094d7373ad223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c7a8e0b859534e14c876f3af7eb9f9625222246cee063865368dc38c6c08ba"
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
