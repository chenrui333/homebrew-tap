class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.6.tgz"
  sha256 "f259ab9f938db8ee09ebcf05e01c3116f50ceb309aa970d22afccd51c756e6f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af5a4cab08f2fceff732c690fa4dbcfab98d98e93d641d5a1440e826425433d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6bc89da6d2ed3653909df9b6aa71dde70144b74e3b5d09fde67580cc5bd66fa"
    sha256 cellar: :any_skip_relocation, ventura:       "c88ea9091bc863628baddfd610ab87080ccfa4f4b0d22d246441011271dda355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ae38ac6df0dcd5e71f78d571e05f9b134b809049bc1e3f80c462d1d15a73e5"
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
