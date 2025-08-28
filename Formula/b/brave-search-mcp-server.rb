class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-1.3.7.tgz"
  sha256 "2b636d7fc369544d798b9f34ac038e60a32edbcd5302cfc8552b727d76877b1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c893b31a758222e17ce98f1544ce96ee5733b84f0c3a55eb475a1b9a98fc806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462b925518d21e41d55a8ba53feda43494d1cfae4da72acb07d70b059ce529ec"
    sha256 cellar: :any_skip_relocation, ventura:       "09c029d384b5fff685f7c69f00519fa179472f413e187c660383624bbdf91f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40901b5b5536ecde8ac6b8d5833373c588c34da3bff3558be40cfa2af4879da"
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
