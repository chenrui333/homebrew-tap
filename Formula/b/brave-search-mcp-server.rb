class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.38.tgz"
  sha256 "02bec1c5b501d72dc84abffb0a6a5c16567468a2d7f40059dfabb085c6296017"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b813d4de7bd38b2933b65346d7070da67e9cf4275c24f4a54ddcaa408962926f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e654e7bbec74fc790838470e8c3467d03e4aeddc50d830451b3fe83a9d3a4498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3fa5dddec1e0aebb1ffb6c28d63f38179ad54df822193f49000eacf1876b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60411de4f8d33e4f2f100ef4b033f57b7699b69c2238ff1969b9ca86ddaf00b"
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
