class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.8.tgz"
  sha256 "e8d082bd431abd6b57e9d4ac13764d44fcd081ebdcd6b1a3b271e5d6935b74a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43c051f4dfffee1fa65dd61ca47fac64e24f4f1534b23157833ef98ecc9f821a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a034c0a271d613f82040b4a21ce2b24025218c08b17573a7ed558fbcc4921385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5da0613357790ebe02b192567599707e0ca00befd55303fbaa6efc75f2c432b"
  end

  depends_on "node"
  depends_on "railway"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
