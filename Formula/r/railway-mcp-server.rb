class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.12.tgz"
  sha256 "b2289aa0762101c69683df73060d1a3d93a5a0b612fe97d24a996e7439ded790"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2684c38c496559cbf01b622b9ddfb2324a36dae682d5cbb6f727958081c67721"
  end

  depends_on "node"
  depends_on "railway"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # The wrapper forwards to `railway mcp`, which reports the missing login without contacting Railway.
    output = pipe_output("#{bin}/railway-mcp-server 2>&1", json, 0)
    assert_match "Not logged in to Railway", output
    assert_match "railway login", output
  end
end
