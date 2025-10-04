class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.26.tgz"
  sha256 "333a7b07f0a080f7d60251807c957578f09787a140d3efd7be345c018fcebeb4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f1f697ebf3d68e55d360a1257384cc66702d1287b29a45db05861bf9edbe4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9559d260994fc1ffcb35d8a708906836c80d3e0ca6476da44b63b25d57284655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d182a42ea090c9285fbb1fbe616ab2e66f307dc56d6ae64281b8f354d2d18810"
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
