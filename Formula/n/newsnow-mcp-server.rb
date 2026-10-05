class NewsnowMcpServer < Formula
  desc "MCP server for NewsNow"
  homepage "https://github.com/ourongxing/newsnow-mcp-server"
  url "https://registry.npmjs.org/newsnow-mcp-server/-/newsnow-mcp-server-0.0.12.tgz"
  sha256 "30e6c42f549447f0059ce8c3f697ddbf769a127fd2877c608133114797b715e4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cab43cd27d44491241c27872667a5854e44beb9bc3922959834a33e11b4e9860"
  end

  depends_on "node"

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
    ENV["BASE_URL"] = "https://newsnow.busiyi.world"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"brew-test","version":"1.0.0"}}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    output = pipe_output("#{bin}/newsnow-mcp-server 2>&1", json)
    assert_match "NewsNow", output
    assert_match "get_hottest_latest_news", output
  end
end
