class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.4.tgz"
  sha256 "cc536db821877e9b26cdb215837f469db4ba1e5cb3139ddfc86e9f4b6b642643"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7b5003b824ac18b2dd53857ac5d55e641dd96460b0871d08ec379f5fc490d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f3be74f44245a93a96ba69134af21ae1cdf3c07348524bc799d0cf8126ec20a"
    sha256 cellar: :any_skip_relocation, ventura:       "d7b4d6ffe96e35c2548068a8ca156a1b3009863eb3d45975eb87b64acb4375b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b858cee60fd38ad3c4af5da2308b7c77baba98e4a06fa34b1cf49cb6d0931b"
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
