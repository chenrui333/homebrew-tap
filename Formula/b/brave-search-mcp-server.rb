class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.26.tgz"
  sha256 "333a7b07f0a080f7d60251807c957578f09787a140d3efd7be345c018fcebeb4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22747e8ff3c9f95bb8773a93fbe41742ca09aea431f256051727d90cb1002d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4948ad2b2d94ef6823cad85a5b0530b1372a600e3f31bb46c54110342df03ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c55707d4494eb8e52a998795e5efa33482a250dbe2278f6ee1b54bb05c9d63f"
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
