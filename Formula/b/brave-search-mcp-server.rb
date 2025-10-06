class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.42.tgz"
  sha256 "7aa989f8f91ba81f6e67ba2d05c5216570d9ade04f38b04896df8afe6a3e9d25"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da76dc7377a6381800a8cab0573ee98ce267fd1c2cb04cec99fbde659081a02f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03a8c9cea4125a4fdb816bed96f9385004f4355daa13bca56361269125670d79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d5343bb921b19f0395a9d9ca921fcd6b5f37fb95a175764d9de99af4e9decb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200b140437df653c48728233393273039b3abbfbe96864eb929714863e37e7b4"
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

    output = pipe_output("#{bin}/brave-search-mcp-server --brave-api-key test --transport stdio 2>&1", json, 0)
    assert_match "Performs web searches using the Brave Search API", output
  end
end
